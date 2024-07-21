from twilio.rest import Client
import firebase_admin
from firebase_admin import credentials, storage
from dotenv import load_dotenv
import tempfile
import os

# Load environment variables from .env file
load_dotenv()

# Initialize Firebase Admin SDK
cred = credentials.Certificate(os.getenv("FIREBASE_CREDENTIALS_PATH"))
firebase_admin.initialize_app(cred, {
    'storageBucket': os.getenv("FIREBASE_STORAGE_BUCKET")
})

# Initialize Firebase Storage
bucket = storage.bucket()

# Initialize Twilio client
account_sid = os.getenv("TWILIO_ACCOUNT_SID")
auth_token = os.getenv("TWILIO_AUTH_TOKEN")
client = Client(account_sid, auth_token)

def send_motion_alert(phone_number, message):
    # Send motion alert message via Twilio
    message = client.messages.create(
        body=message,
        from_=os.getenv("TWILIO_PHONE_NUMBER"),
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
