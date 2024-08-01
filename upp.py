from flask import Flask, Response, stream_with_context
from flask_cors import CORS
import subprocess

app = Flask(__name__)
CORS(app)

def generate_frames():
    ffmpeg_command = [
        'ffmpeg',
        '-f', 'v4l2',          # Use Video4Linux2 (for Linux systems)
        '-i', '/dev/video0',   # Input device
        '-f', 'mpegts',        # Output format
        '-codec:v', 'mpeg1video',  # Video codec
        '-s', '640x480',       # Output resolution
        '-b:v', '800k',        # Bitrate
        '-bf', '0',            # No B-frames
        '-'
    ]
    process = subprocess.Popen(ffmpeg_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    @stream_with_context
    def stream():
        while True:
            frame = process.stdout.read(1024)
            if not frame:
                break
            yield frame

    return stream

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='video/mp2t')

@app.route('/')
def index():
    return "Video streaming server is running."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8556, debug=True)
