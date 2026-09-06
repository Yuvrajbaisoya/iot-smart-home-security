import json
import random
import time

import paho.mqtt.client as mqtt

DEVICE_ID = "sensor_001"
BROKER = "localhost"
PORT = 1883
TOPIC = "smarthome/sensor"

client = mqtt.Client(
    callback_api_version=mqtt.CallbackAPIVersion.VERSION2
)

client.connect(BROKER, PORT, 60)
client.loop_start()

print("Sensor simulator started...")

try:
    while True:
        data = {
            "device_id": DEVICE_ID,
            "type": "temperature_sensor",
            "temperature": random.randint(20, 35),
            "humidity": random.randint(40, 80)
        }

        message = json.dumps(data)

        client.publish(TOPIC, message)

        print("Sensor Data Sent:", message)

        time.sleep(5)

except KeyboardInterrupt:
    print("\nSensor stopped.")

finally:
    client.loop_stop()
    client.disconnect()
