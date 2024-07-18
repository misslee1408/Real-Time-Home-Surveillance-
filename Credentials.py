from twilio.rest import Client
import firebase_admin
from firebase_admin import credentials, storage, initialize_app
import tempfile
import os
import config  # Ensure Config.py contains your Twilio credentials and Firebase service account key path

# Initialize Twilio client
account_sid = config.TWILIO_ACCOUNT_SID
auth_token = config.TWILIO_AUTH_TOKEN
client = Client(account_sid, auth_token)

# Initialize Firebase Storage
bucket = storage.bucket()
# Initialize Firebase Admin SDK
cred = credentials.Certificate(r"C:\Users\bsc_com_ne_05_19\\Music\Real-Time-Home-Surveillance-\real-time-home-surveillance-firebase-adminsdk-xiafw-6581799d9b.JSON")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'real-time-home-surveillance.appspot.com'
})

def send_motion_alert(phone_number, message):
    # Send motion alert message via Twilio
    message = client.messages.create(
        body=message,
        from_=config.TWILIO_PHONE_NUMBER,
        to=phone_number
    )
    return message.sid

def upload_file_to_firebase(file_path, filename):
    # Upload file to Firebase Storage
    blob = bucket.blob(filename)
    blob.upload_from_filename(file_path)
    blob.make_public()
    return blob.public_url

if __name__ == "__main__":
    # Example usage:
    phone_number = '+265881978126'
    message = "Motion detected in your home. Check your security camera for more details."
    
    # Send motion alert message
    message_sid = send_motion_alert(phone_number, message)
    print(f"Message sent with SID: {message_sid}")
    
    # Upload a sample file to Firebase Storage
    with tempfile.NamedTemporaryFile(delete=False) as tmpfile:
        tmpfile.write(b"Sample content")  # Replace with actual file content
        tmpfile_path = tmpfile.name
        filename = os.path.basename(tmpfile_path)
        
        # Upload file to Firebase Storage
        photo_url = upload_file_to_firebase(tmpfile_path, filename)
        print(f"File uploaded to Firebase Storage: {photo_url}")
        
        os.remove(tmpfile_path)  # Clean up temp file
