from twilio.rest import Client
from firebase_admin import credentials, storage, initialize_app
import tempfile
import os
import config  # Ensure Config.py contains your Twilio credentials and Firebase service account key path

# Initialize Twilio client
account_sid = config.TWILIO_ACCOUNT_SID
auth_token = config.TWILIO_AUTH_TOKEN
client = Client(account_sid, auth_token)

# Initialize Firebase Admin SDK
cred = credentials.Certificate(config.FIREBASE_SERVICE_ACCOUNT_KEY_PATH)
initialize_app(cred, {'storageBucket': config.FIREBASE_STORAGE_BUCKET})
bucket = storage.bucket()

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
