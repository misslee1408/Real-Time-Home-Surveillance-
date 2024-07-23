import RPi.GPIO as GPIO
import time
from picamera import PiCamera

# Set up GPIO
GPIO.setmode(GPIO.BCM)
PIR_PIN = 17
GPIO.setup(PIR_PIN, GPIO.IN)

camera = PiCamera()

# Set video resolution and framerate (adjust as needed)
camera.resolution = (640, 480)
camera.framerate = 30

# Variable to track whether we are currently recording
recording = False

def motion_detected(channel):
    global recording
    print("Motion detected!")
    if not recording:
        # Start recording video when motion is detected
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        filename = f"motion_{timestamp}.h264"
        camera.start_recording(filename)
        print(f"Started recording: {filename}")
        recording = True

GPIO.add_event_detect(PIR_PIN, GPIO.RISING, callback=motion_detected)

try:
    print("PIR Module Test (Ctrl+C to exit)")
    while True:
        time.sleep(1)

except KeyboardInterrupt:
    print("Exiting")
    GPIO.cleanup()
    if recording:
        camera.stop_recording()
    camera.close()

