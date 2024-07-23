import RPi.GPIO as GPIO
import time
from picamera import PiCamera

# Set up GPIO
GPIO.setmode(GPIO.BCM)
PIR_PIN = 17
GPIO.setup(PIR_PIN, GPIO.IN)

camera = PiCamera()

def motion_detected(channel):
    print("Motion detected!")
    # Capture image when motion is detected
    timestamp = time.strftime("%Y%m%d_%H%M%S")
    filename = f"motion_{timestamp}.jpg"
    camera.capture(filename)
    print(f"Motion captured: {filename}")

GPIO.add_event_detect(PIR_PIN, GPIO.RISING, callback=motion_detected)

try:
    print("PIR Module Test (Ctrl+C to exit)")
    while True:
        time.sleep(1)

except KeyboardInterrupt:
    print("Exiting")
    GPIO.cleanup()
    camera.close()

