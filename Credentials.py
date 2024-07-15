from twilio.rest import Client
import Config

# Your Account SID and Auth Token from twilio.com/console
account_sid = Config.TWILIO_ACCOUNT_SID
auth_token = Config.TWILIO_AUTH_TOKEN
client = Client(account_sid, auth_token)


def send_motion_alert(phone_number, message):
    message = client.messages.create(
        body=message,
        from_=Config.TWILIO_PHONE_NUMBER,  # Your Twilio phone number (must be a validated number on Twilio)
        to=phone_number
    )
    return message.sid

# Example usage (correcting the if __name__ == "__main__": block)
if __name__ == "__main__":
    # The phone number to which you want to send the notification
    phone_number = '+265881680849'
    # The message you want to send
    message = "Motion detected in your home. Check your security camera for more details."

    # Call the function to send the alert
    message_sid = send_motion_alert(phone_number, message)
    print(f"Message sent with SID: {message_sid}")



    
def motion_detected():
    phone_number = '+13344234464'
    message = "Motion detected in your home. Check your security camera for more details."
    send_motion_alert(phone_number, message)
