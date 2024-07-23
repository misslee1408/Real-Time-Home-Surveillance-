from flask import Flask, Response
from flask_cors import CORS
import cv2
from flask_httpauth import HTTPBasicAuth

app = Flask(__name__)
CORS(app)# Enable CORS for allroutes
auth = HTTPBasicAuth()

# Replace with your own username and password
users = {
    "admin": "password"
}

@auth.get_password
def get_pw(username):
    if username in users:
        return users.get(username)
    return None

def generate_frames():
    camera = cv2.VideoCapture(0)  # Use your camera index if different
    while True:
        success, frame = camera.read()
        if not success:
            break
        else:
            ret, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/')
@auth.login_required
def index():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8555)
 

