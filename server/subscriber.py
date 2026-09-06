import os
import sys
import datetime

import paho.mqtt.client as mqtt

PROJECT_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
)

sys.path.append(PROJECT_DIR)

from security.encryption import generate_key, encrypt_data

BROKER = "localhost"
PORT = 1883

DATA_FILE = os.path.join(
    PROJECT_DIR,
    "data",
    "encrypted_data.txt"
)

LOG_FILE = os.path.join(
    PROJECT_DIR,
    "logs",
    "activity.log"
)

generate_key()


def save_encrypted_data(data):
    encrypted = encrypt_data(data)

    with open(DATA_FILE, "ab") as file:
        file.write(encrypted + b"\n")


def log_message(message):
    timestamp = datetime.datetime.now().isoformat()

    with open(LOG_FILE, "a") as file:
        file.write(
            f"{timestamp} | {message}\n"
        )


def on_connect(
    client,
    userdata,
    flags,
    reason_code,
    properties=None
):
    print("Connected to MQTT Broker")

    client.subscribe("smarthome/#")


def on_message(client, userdata, message):
    payload = message.payload.decode()

    print("\n--------------------------")
    print("Topic:", message.topic)
    print("Message:", payload)
    print("--------------------------")

    log_message(
        f"Topic={message.topic} Payload={payload}"
    )

    save_encrypted_data(payload)


client = mqtt.Client(
    callback_api_version=mqtt.CallbackAPIVersion.VERSION2
)

client.on_connect = on_connect
client.on_message = on_message

print("Connecting to MQTT Broker...")

client.connect(BROKER, PORT, 60)

client.loop_forever()
