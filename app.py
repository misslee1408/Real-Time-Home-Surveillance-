import subprocess
from flask import Flask, Response

app = Flask(__name__)

def generate_frames():
    gstreamer_command = [
        'gst-launch-1.0', 'v4l2src', '!', 'videoconvert', '!', 'x264enc', '!', 'mpegtsmux', '!', 'tcpserversink', 'host=0.0.0.0', 'port=5000'
    ]
    process = subprocess.Popen(gstreamer_command, stdout=subprocess.PIPE)
    while True:
        frame = process.stdout.read(1024)
        if not frame:
            break
        yield frame

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='video/mp2t')

@app.route('/')
def index():
    return "Video streaming server is running."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
