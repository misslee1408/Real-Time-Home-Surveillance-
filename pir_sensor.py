import RPi.GPIO as GPIO
import time

# Set up GPIO
GPIO.setmode(GPIO.BCM)
PIR_PIN = 17
GPIO.setup(PIR_PIN, GPIO.IN)

def motion_detected(channel):
    print("Motion detected!")

GPIO.add_event_detect(PIR_PIN, GPIO.RISING, callback=motion_detected)

try:
    print("PIR Module Test (Ctrl+C to exit)")
    while True:
        time.sleep(1)

except KeyboardInterrupt:
    print("Exiting")
    GPIO.cleanup()



