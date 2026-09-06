import json
import random
import time

import paho.mqtt.client as mqtt

DEVICE_ID = "camera_001"
BROKER = "localhost"
PORT = 1883
TOPIC = "smarthome/camera"

client = mqtt.Client(
    callback_api_version=mqtt.CallbackAPIVersion.VERSION2
)

client.connect(BROKER, PORT, 60)
client.loop_start()

print("Camera simulator started...")

try:
    while True:
        data = {
            "device_id": DEVICE_ID,
            "type": "smart_camera",
            "motion": random.choice([
                "detected",
                "not_detected"
            ]),
            "status": "online"
        }

        message = json.dumps(data)

        client.publish(TOPIC, message)

        print("Camera Data Sent:", message)

        time.sleep(7)

except KeyboardInterrupt:
    print("\nCamera stopped.")

finally:
    client.loop_stop()
    client.disconnect()
