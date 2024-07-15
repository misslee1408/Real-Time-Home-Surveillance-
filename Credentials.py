from flask import Flask, render_template, request
from twilio.rest import Client

app = Flask(__name__)

# Your Account SID and Auth Token from twilio.com/console
account_sid = 'ACa6563cbfd1186d359d3a0e280c707749'
auth_token = 'fdb7d1fd091ff26e6cfc57212b36edee'
client = Client(account_sid, auth_token)

def send_motion_alert(phone_number, message):
    message = client.messages.create(
        body=message,
        from_='+13344234464',  # Your Twilio phone number (must be a validated number on Twilio)
        to=phone_number
    )
    return message.sid

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/motion_detected', methods=['POST'])
def motion_detected():
    phone_number = '+265881680849'
    message = "Motion detected in your home. Check your security camera for more details."
    message_sid = send_motion_alert(phone_number, message)
    return f"Message sent with SID: {message_sid}"

if __name__ == "__main__":
    app.run(debug=True)
