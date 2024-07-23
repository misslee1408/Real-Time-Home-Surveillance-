from flask import Flask, render_template, request
from twilio.rest import Client
import config
import firebase_admin
from firebase_admin import credentials, firestore, storage
import os
from werkzeug.utils import secure_filename
import tempfile

app = Flask(__name__)

# Your Account SID and Auth Token from twilio.com/console
account_sid = config.TWILIO_ACCOUNT_SID
auth_token = config.TWILIO_AUTH_TOKEN
client = Client(account_sid, auth_token)

# Initialize Firebase Admin SDK
cred = credentials.Certificate(os.getenv("FIREBASE_CREDENTIALS_PATH"))
firebase_admin.initialize_app(cred, {
    'storageBucket': os.getenv("FIREBASE_STORAGE_BUCKET")
})

# Set the upload folder
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure the upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

# Firestore client
db = firestore.client()
bucket = storage.bucket()

def send_motion_alert(phone_number, message):
    message = client.messages.create(
        body=message,
        from_=config.TWILIO_PHONE_NUMBER,  # Your Twilio phone number (must be a validated number on Twilio)
        to=phone_number
    )
    return message.sid

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/motion_detected', methods=['POST'])
def motion_detected():
    phone_number = '+265881978126'
    message = "Motion detected in your home. Check your security camera for more details."
    
    # Handle file upload
    if 'photo' not in request.files:
        return "No file part"
    file = request.files['photo']
    if file.filename == '':
        return "No selected file"
    if file:
        filename = secure_filename(file.filename)
        
        # Create a temporary directory to save the file
        with tempfile.TemporaryDirectory() as tmpdirname:
            file_path = os.path.join(tmpdirname, filename)
            file.save(file_path)

            # Upload the file to Firebase Storage
            blob = bucket.blob(filename)
            blob.upload_from_filename(file_path)
            blob.make_public()  # Make the file public, you can control access differently if needed
            photo_url = blob.public_url

        # Log the alert in Firestore
        alert_data = {
            'phone_number': phone_number,
            'message': message,
            'message_sid': send_motion_alert(phone_number, message),
            'photo_url': photo_url
        }
        db.collection('alerts').add(alert_data)

    return f"Message sent with SID: {alert_data['message_sid']} and photo uploaded to {photo_url}"

if __name__ == "__main__":
    app.run(debug=True)
