import datetime
from flask import Flask, render_template, request, send_from_directory
from twilio.rest import Client
import config
import firebase_admin
from firebase_admin import credentials, firestore, storage
import os
from werkzeug.utils import secure_filename
import tempfile

app = Flask(__name__)

# Initialize Firebase Admin SDK
cred = credentials.Certificate(os.getenv("FIREBASE_CREDENTIALS_PATH"))
firebase_admin.initialize_app(cred, {
    'storageBucket': os.getenv("FIREBASE_STORAGE_BUCKET")
})

# Firestore client
db = firestore.client()
bucket = storage.bucket()


# Your Account SID and Auth Token from twilio.com/console
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


@app.route('/add_video', methods = ['POST'])
def add_video():
    if 'video' not in request.files:
        return jsonify({"error": "No video part in the request"}), 400
    
    file = request.files['video']
    
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    
    if file:
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        # Store video metadata in Firestore
        timestamp = datetime.now().isoformat()
        doc_ref = db.collection('VideoCollection').document()
        doc_ref.set({
            'filename': filename,
            'timestamp': timestamp
        })


 # Send SMS notification
        message = client.messages.create(
            body=f"Motion detected! Video ID: {doc_ref.id}, Time: {timestamp}",
            from_=config.TWILIO_PHONE_NUMBER,  # Your Twilio phone number (must be a validated number on Twilio)
        to=phone_number
        )

    return jsonify({
            "document_id": doc_ref.id,
            "timestamp": timestamp
        })

@app.route('/videos')
def videos():
    # Fetch video metadata from Firestore
    videos = []
    docs = db.collection('VideoCollection').stream()
    for doc in docs:
        videos.append(doc.to_dict())

    return render_template('videos.html', videos=videos)

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    app.run(debug=True)