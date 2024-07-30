import cv2
from flask import Flask, render_template, request, send_from_directory, jsonify, Response
from twilio.rest import Client
import config
import firebase_admin
from firebase_admin import credentials, firestore, storage
import os
from werkzeug.utils import secure_filename
import tempfile
import datetime

app = Flask(__name__)

# Initialize Firebase Admin SDK
cred = credentials.Certificate(os.getenv("FIREBASE_CREDENTIALS_PATH"))
firebase_admin.initialize_app(cred, {
    'storageBucket': os.getenv("FIREBASE_STORAGE_BUCKET")
})

# Firestore client
db = firestore.client()
bucket = storage.bucket()

# Twilio Client
account_sid = config.TWILIO_ACCOUNT_SID
auth_token = config.TWILIO_AUTH_TOKEN
TWILIO_PHONE_NUMBER = config.TWILIO_PHONE_NUMBER 
USER_PHONE_NUMBER = config.USER_PHONE_NUMBER
client = Client(account_sid, auth_token)

# Set the upload folder
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure the upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/')
def index():
    return render_template('index.html')

def generate_frames():
    cap = cv2.VideoCapture('http://41.70.47.48:8556/')  
    while True:
        success, frame = cap.read()
        if not success:
            break
        else:
            ret, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()
            yield (b'--frame\r\n'
                    b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    app.run(debug=True)
def save_and_upload_video():
    cap = cv2.VideoCapture('http://41.70.47.48:8556/')  
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    temp_dir = tempfile.mkdtemp()
    video_path = os.path.join(temp_dir, 'output.avi')
    out = cv2.VideoWriter(video_path, fourcc, 20.0, (640,480))

    while True:
        success, frame = cap.read()
        if not success:
            break
        out.write(frame)

    cap.release()
    out.release()
    
    # Upload to Firebase Storage
    blob = bucket.blob(f'videos/{datetime.datetime.now().isoformat()}.avi')
    blob.upload_from_filename(video_path)

    # Save metadata in Firestore
    doc_ref = db.collection('VideoCollection').document()
    doc_ref.set({
        'filename': blob.name,
        'timestamp': datetime.datetime.now().isoformat(),
        'url': blob.public_url
    })

    # Send SMS notification
    message = client.messages.create(
        body=f"Motion detected! Video ID: {doc_ref.id}, Time: {datetime.datetime.now().isoformat()}",
        from_=TWILIO_PHONE_NUMBER,
        to=USER_PHONE_NUMBER
    )

    os.remove(video_path)

@app.route('/start_capture')
def start_capture():
    # Trigger video capture and upload
    save_and_upload_video()
    return "Capture started", 200
