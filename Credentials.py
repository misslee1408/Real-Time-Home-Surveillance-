import logging
import datetime
import cv2
from flask import Flask, render_template, request, jsonify, Response
from twilio.rest import Client
import config
import firebase_admin
from firebase_admin import credentials, firestore
import os
from werkzeug.utils import secure_filename
import tempfile
import threading
import time

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Initialize Firebase Admin SDK
try:
    cred = credentials.Certificate(os.getenv("FIREBASE_CREDENTIALS_PATH"))
    firebase_admin.initialize_app(cred)
    logger.info("Firebase initialized successfully.")
except Exception as e:
    logger.error(f"Error initializing Firebase: {e}")

# Firestore client
db = firestore.client()

# Twilio Client
try:
    account_sid = config.TWILIO_ACCOUNT_SID
    auth_token = config.TWILIO_AUTH_TOKEN
    TWILIO_PHONE_NUMBER = config.TWILIO_PHONE_NUMBER 
    USER_PHONE_NUMBER = config.USER_PHONE_NUMBER
    client = Client(account_sid, auth_token)
    logger.info("Twilio client initialized successfully.")
except Exception as e:
    logger.error(f"Error initializing Twilio client: {e}")

# Set the upload folder
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure the upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
    logger.info("Upload folder created.")

@app.route('/')
def index():
    return render_template('index.html')

def generate_frames():
    try:
        cap = cv2.VideoCapture('rtsp://41.70.47.48/:544/Streaming/channels/101')  
        while True:
            success, frame = cap.read()
            if not success:
                logger.warning("Failed to read frame from camera.")
                break
            else:
                ret, buffer = cv2.imencode('.jpg', frame)
                if not ret:
                    logger.warning("Failed to encode frame.")
                    continue
                frame = buffer.tobytes()
                yield (b'--frame\r\n'
                        b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
        cap.release()
    except Exception as e:
        logger.error(f"Error generating frames: {e}")

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

def save_and_upload_video():
    try:
        cap = cv2.VideoCapture('rtsp://41.70.47.48/:544/Streaming/channels/101')  
        fourcc = cv2.VideoWriter_fourcc(*'XVID')
        temp_dir = tempfile.mkdtemp()
        video_path = os.path.join(temp_dir, 'output.avi')
        out = cv2.VideoWriter(video_path, fourcc, 20.0, (640,480))

        while True:
            success, frame = cap.read()
            if not success:
                logger.warning("Failed to read frame from camera.")
                break
            out.write(frame)

        cap.release()
        out.release()
        
        # Save metadata in Firestore
        doc_ref = db.collection('VideoCollection').document()
        doc_ref.set({
            'filename': 'output.avi',
            'timestamp': datetime.datetime.now().isoformat(),
        })
        logger.info(f"Video metadata saved to Firestore: {doc_ref.id}")

        # Send SMS notification
        message = client.messages.create(
            body=f"Motion detected! Video ID: {doc_ref.id}, Time: {datetime.datetime.now().isoformat()}",
            from_=TWILIO_PHONE_NUMBER,
            to=USER_PHONE_NUMBER
        )
        logger.info(f"SMS notification sent: {message.sid}")

        os.remove(video_path)
    except Exception as e:
        logger.error(f"Error in save_and_upload_video: {e}")

@app.route('/start_capture')
def start_capture():
    try:
        # Trigger video capture and upload
        save_and_upload_video()
        return "Capture started", 200
    except Exception as e:
        logger.error(f"Error starting capture: {e}")
        return jsonify({"error": "Failed to start capture"}), 500

def scheduled_capture(interval=60):
    while True:
        try:
            save_and_upload_video()
            time.sleep(interval)
        except Exception as e:
            logger.error(f"Error in scheduled capture: {e}")

if __name__ == '__main__':
    try:
        capture_thread = threading.Thread(target=scheduled_capture, args=(60,))  # Capture every 60 seconds
        capture_thread.start()
        logger.info("Scheduled capture thread started.")
        app.run(debug=True)
    except Exception as e:
        logger.error(f"Error running Flask application: {e}")
