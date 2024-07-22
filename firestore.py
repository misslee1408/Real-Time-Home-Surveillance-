import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate(r"C:\Users\bsc_com_ne_05_19\Desktop\app\env\real-time-home-surveillance-firebase-adminsdk-xiafw-6581799d9b.JSON")
firebase_admin.initialize_app(cred)
