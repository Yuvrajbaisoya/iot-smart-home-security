import json
import random
import time

import paho.mqtt.client as mqtt

DEVICE_ID = "lock_001"
BROKER = "localhost"
PORT = 1883
TOPIC = "smarthome/lock"

client = mqtt.Client(
    callback_api_version=mqtt.CallbackAPIVersion.VERSION2
)

client.connect(BROKER, PORT, 60)
client.loop_start()

print("Smart Lock simulator started...")

try:
    while True:
        data = {
            "device_id": DEVICE_ID,
            "type": "smart_lock",
            "status": random.choice([
                "LOCKED",
                "UNLOCKED"
            ])
        }

        message = json.dumps(data)

        client.publish(TOPIC, message)

        print("Lock Status Sent:", message)

        time.sleep(10)

except KeyboardInterrupt:
    print("\nSmart Lock stopped.")

finally:
    client.loop_stop()
    client.disconnect()
