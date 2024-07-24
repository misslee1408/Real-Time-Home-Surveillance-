
from flask import Flask, render_template
from flask_cors import CORS
from flask_httpauth import HTTPBasicAuth
from flask_socketio import SocketIO, emit
import cv2
import base64

upp = Flask(__name__)
CORS(upp)  # Enable CORS for all routes
auth = HTTPBasicAuth()
socketio = SocketIO(upp)

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
    try:
        while True:
            success, frame = camera.read()
            if not success:
                break
            else:
                ret, buffer = cv2.imencode('.jpg', frame)
                frame = base64.b64encode(buffer).decode('utf-8')
                socketio.emit('video_frame', {'frame': frame})
                socketio.sleep(0.1)  # Adjust the sleep time as needed
    finally:
        camera.release()
        cv2.destroyAllWindows()


@upp.route('/')
@auth.login_required
def index():
    return render_template('index.html')

@socketio.on('connect')
def handle_connect():
    print("Client connected")

@socketio.on('disconnect')
def handle_disconnect():
    print("Client disconnected")

if __name__ == '__main__':
    socketio.start_background_task(target=generate_frames)
    socketio.run(upp, host='0.0.0.0', port=8556)
