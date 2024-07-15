# Config.py
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Assign the environment variables to variables in your code
TWILIO_ACCOUNT_SID = os.getenv('TWILIO_ACCOUNT_SID')
TWILIO_AUTH_TOKEN = os.getenv('TWILIO_AUTH_TOKEN')
TWILIO_PHONE_NUMBER = os.getenv('TWILIO_PHONE_NUMBER')
