#!/bin/bash

set -e

PROJECT="$HOME/iot-smart-home-security"

cd "$PROJECT"

echo "[+] Creating project folders..."

mkdir -p devices
mkdir -p server
mkdir -p security
mkdir -p monitoring
mkdir -p firmware
mkdir -p data
mkdir -p logs
mkdir -p docs
mkdir -p tests
mkdir -p architecture

echo "[+] Creating requirements.txt..."

cat > requirements.txt <<'REQ'
paho-mqtt
cryptography
REQ

echo "[+] Creating .gitignore..."

cat > .gitignore <<'IGNORE'
__pycache__/
*.pyc
*.key
*.pem
*.crt
*.log
security/secret.key
data/encrypted_data.txt
IGNORE

echo "[+] Creating authentication module..."

cat > security/auth.py <<'PY'
DEVICES = {
    "sensor_001": {
        "username": "sensor_user",
        "password": "sensor_pass_123",
        "role": "sensor"
    },
    "camera_001": {
        "username": "camera_user",
        "password": "camera_pass_123",
        "role": "camera"
    },
    "lock_001": {
        "username": "lock_user",
        "password": "lock_pass_123",
        "role": "lock"
    }
}


def authenticate_device(device_id, username, password):
    if device_id not in DEVICES:
        return False

    device = DEVICES[device_id]

    return (
        device["username"] == username
        and device["password"] == password
    )


def get_device_role(device_id):
    if device_id in DEVICES:
        return DEVICES[device_id]["role"]

    return None
PY

echo "[+] Creating RBAC module..."

cat > security/rbac.py <<'PY'
ROLES = {
    "admin": [
        "view_camera",
        "control_lock",
        "view_sensor",
        "manage_devices"
    ],
    "owner": [
        "view_camera",
        "control_lock",
        "view_sensor"
    ],
    "guest": [
        "view_sensor"
    ]
}


def check_permission(role, permission):
    if role not in ROLES:
        return False

    return permission in ROLES[role]


def show_permissions(role):
    return ROLES.get(role, [])
PY

echo "[+] Creating encryption module..."

cat > security/encryption.py <<'PY'
from cryptography.fernet import Fernet
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
KEY_FILE = os.path.join(BASE_DIR, "secret.key")


def generate_key():
    if not os.path.exists(KEY_FILE):
        key = Fernet.generate_key()

        with open(KEY_FILE, "wb") as file:
            file.write(key)

        print("Encryption key generated.")
    else:
        print("Encryption key already exists.")


def load_key():
    if not os.path.exists(KEY_FILE):
        generate_key()

    with open(KEY_FILE, "rb") as file:
        return file.read()


def encrypt_data(data):
    key = load_key()
    cipher = Fernet(key)

    return cipher.encrypt(data.encode())


def decrypt_data(encrypted_data):
    key = load_key()
    cipher = Fernet(key)

    return cipher.decrypt(encrypted_data).decode()
PY

echo "[+] Creating sensor simulator..."

cat > devices/sensor.py <<'PY'
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
PY

echo "[+] Creating camera simulator..."

cat > devices/camera.py <<'PY'
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
PY

echo "[+] Creating smart lock simulator..."

cat > devices/smart_lock.py <<'PY'
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
PY

echo "[+] Creating MQTT subscriber..."

cat > server/subscriber.py <<'PY'
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
PY

echo "[+] Creating monitoring module..."

cat > monitoring/monitor.py <<'PY'
import os
import time

PROJECT_DIR = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        ".."
    )
)

LOG_FILE = os.path.join(
    PROJECT_DIR,
    "logs",
    "activity.log"
)

KNOWN_DEVICES = [
    "sensor_001",
    "camera_001",
    "lock_001"
]


def check_activity(line):
    for device in KNOWN_DEVICES:
        if device in line:
            return

    print("\nALERT: Unknown Device Activity!")
    print(line)


def monitor():
    print("IoT Security Monitoring Started...")

    last_position = 0

    while True:

        if os.path.exists(LOG_FILE):

            with open(LOG_FILE, "r") as file:

                file.seek(last_position)

                lines = file.readlines()

                last_position = file.tell()

                for line in lines:
                    check_activity(line)

        time.sleep(3)


if __name__ == "__main__":
    monitor()
PY

echo "[+] Creating firmware integrity module..."

cat > security/firmware_security.py <<'PY'
import hashlib
import os

PROJECT_DIR = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        ".."
    )
)

FIRMWARE_FILE = os.path.join(
    PROJECT_DIR,
    "firmware",
    "firmware_v1.txt"
)

HASH_FILE = os.path.join(
    PROJECT_DIR,
    "firmware",
    "firmware_hash.txt"
)


def calculate_hash(file_path):

    sha256 = hashlib.sha256()

    with open(file_path, "rb") as file:

        while True:

            data = file.read(4096)

            if not data:
                break

            sha256.update(data)

    return sha256.hexdigest()


def sign_firmware():

    firmware_hash = calculate_hash(
        FIRMWARE_FILE
    )

    with open(HASH_FILE, "w") as file:

        file.write(firmware_hash)

    print("\nFirmware integrity hash created:")
    print(firmware_hash)


def verify_firmware():

    if not os.path.exists(HASH_FILE):

        print("Firmware signature/hash not found.")
        return

    current_hash = calculate_hash(
        FIRMWARE_FILE
    )

    with open(HASH_FILE, "r") as file:

        original_hash = file.read().strip()

    if current_hash == original_hash:

        print(
            "\nFirmware VERIFIED"
        )

        print(
            "Integrity check passed."
        )

    else:

        print(
            "\nWARNING: Firmware MODIFIED!"
        )

        print(
            "Installation BLOCKED."
        )


print("\nIoT Firmware Security")

print("1. Generate Firmware Hash")
print("2. Verify Firmware")

choice = input("\nChoose option: ")

if choice == "1":
    sign_firmware()

elif choice == "2":
    verify_firmware()

else:
    print("Invalid option")
PY

echo "[+] Creating firmware sample..."

cat > firmware/firmware_v1.txt <<'TXT'
SMART HOME DEVICE FIRMWARE VERSION 1.0

Modules:
- Device Boot Sequence
- Authentication Module
- Sensor Management
- Secure Communication Module
TXT

echo "[+] Creating security policy..."

cat > docs/iot_security_policy.md <<'MD'
# IoT Security Policy

## 1. Authentication

All IoT devices must have unique identities and credentials.
Default passwords must not be used in production.

## 2. Authorization

Role-Based Access Control (RBAC) must restrict users to the minimum permissions required.

## 3. Encryption

Data in transit should use TLS.
Sensitive data at rest must be encrypted.

## 4. Network Security

IoT devices should be isolated from user and critical networks through segmentation.

## 5. Firmware Updates

Firmware updates must be authenticated and integrity-checked before installation.

## 6. Monitoring

Security events and device activity must be logged and monitored.

## 7. Incident Response

Affected devices should be identified, isolated, investigated, remediated, and restored.
MD

echo "[+] Creating incident response plan..."

cat > docs/incident_response.md <<'MD'
# IoT Security Incident Response Plan

1. Detect suspicious activity.
2. Identify the affected device.
3. Isolate the affected device or network segment.
4. Preserve relevant logs.
5. Investigate the incident.
6. Remove the cause of compromise.
7. Patch or update the affected system.
8. Restore normal operations.
9. Document findings and improvements.
MD

echo "[+] Creating README..."

cat > README.md <<'MD'
# Securing IoT Devices in Smart Home Environments

## Project Overview

This project demonstrates a prototype security framework for a simulated smart home IoT environment.

The environment contains simulated:

- Temperature and humidity sensor
- Smart camera
- Smart lock

The project demonstrates security concepts including authentication, authorization, encrypted data storage, firmware integrity verification, activity logging, monitoring, and incident response planning.

## Architecture

```text
IoT Devices
    |
    | MQTT Communication
    v
MQTT Broker
    |
    v
Secure Subscriber
    |
    +--> Activity Logs
    |
    +--> Encrypted Data Storage
    |
    +--> Monitoring
