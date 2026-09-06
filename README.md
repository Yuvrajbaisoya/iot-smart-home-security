# 🏠 Securing IoT Devices in Smart Home Environments

> A practical cybersecurity project demonstrating authentication, access control, encryption, firmware integrity verification, MQTT communication, and security monitoring in a simulated smart home environment.

![Python](https://img.shields.io/badge/Python-3.x-blue.svg)
![MQTT](https://img.shields.io/badge/Protocol-MQTT-green.svg)
![Security](https://img.shields.io/badge/Focus-IoT%20Security-red.svg)
![License](https://img.shields.io/badge/Project-Educational-orange.svg)

---

## 📌 Overview

The Internet of Things (IoT) has become an important part of modern smart homes. Devices such as temperature sensors, security cameras, and smart locks constantly communicate across networks.

However, insecure communication, weak authentication, unauthorized devices, and firmware tampering can introduce serious security risks.

This project demonstrates a simplified **IoT security framework** designed around multiple security layers.

The simulated smart home environment includes:

* 🌡️ Temperature Sensor
* 📷 Smart Camera
* 🔐 Smart Lock

The devices communicate using the **MQTT protocol**, while a secure subscriber processes incoming messages, logs activity, encrypts stored data, and supports basic security monitoring.

---

# 🏗️ Project Architecture

```text
                         ┌─────────────────────┐
                         │   IoT Smart Devices │
                         │                     │
                         │  🌡️ Sensor          │
                         │  📷 Camera          │
                         │  🔐 Smart Lock      │
                         └──────────┬──────────┘
                                    │
                                    │ MQTT Communication
                                    ▼
                         ┌─────────────────────┐
                         │    MQTT Broker     │
                         │     Mosquitto      │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │  Secure Subscriber │
                         └──────────┬──────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
              ▼                     ▼                     ▼
      ┌───────────────┐    ┌─────────────────┐   ┌─────────────────┐
      │ Activity Logs │    │ Encrypted Data  │   │ Security Monitor│
      └───────────────┘    └─────────────────┘   └─────────────────┘
                                                          │
                                                          ▼
                                               🚨 Unknown Device Alert
```

---

# 🔐 Security Features

## 1️⃣ Device Authentication

Registered IoT devices are validated using device credentials.

Example registered devices:

```text
sensor_001
camera_001
lock_001
```

The authentication module verifies:

* Device ID
* Username
* Password

Unauthorized credentials are rejected.

---

## 2️⃣ Role-Based Access Control (RBAC)

The project implements a basic RBAC system to control device permissions.

| Role  | Permissions                                             |
| ----- | ------------------------------------------------------- |
| Admin | View camera, control lock, view sensors, manage devices |
| Owner | View camera, control lock, view sensors                 |
| Guest | View sensors only                                       |

Example:

```python
check_permission("admin", "manage_devices")
```

Expected result:

```text
True
```

Unauthorized actions return:

```text
False
```

---

## 3️⃣ Data Encryption

Incoming MQTT device messages are encrypted before being stored.

The project uses:

```text
Fernet Symmetric Encryption
```

Flow:

```text
IoT Device Data
       │
       ▼
 MQTT Message
       │
       ▼
Secure Subscriber
       │
       ▼
Encryption Layer
       │
       ▼
Encrypted Storage
```

The encrypted data is stored in:

```text
data/encrypted_data.txt
```

---

## 4️⃣ Firmware Integrity Verification

Firmware integrity is checked using the SHA-256 hashing algorithm.

### Generate Firmware Hash

```bash
python security/firmware_security.py
```

Select:

```text
1
```

Example output:

```text
Firmware integrity hash created:
963bafaf568f3ee5e6b92814499e8889982d75100069d1d7e9aa68d15ed17ec3
```

### Verify Firmware

Run again:

```bash
python security/firmware_security.py
```

Select:

```text
2
```

Expected result:

```text
Firmware VERIFIED
Integrity check passed.
```

If the firmware file is modified after the reference hash is generated:

```text
WARNING: Firmware MODIFIED!
Installation BLOCKED.
```

---

## 5️⃣ Security Monitoring

The monitoring module continuously checks device activity logs.

Known devices include:

```text
sensor_001
camera_001
lock_001
```

If activity is detected from an unknown device, the system generates an alert.

Example:

```text
ALERT: Unknown Device Activity!

Topic=smarthome/unknown
Payload={
    "device_id": "hacker_device_999",
    "type": "unknown_sensor",
    "status": "active"
}
```

This demonstrates basic detection of unauthorized IoT devices.

---

# 📂 Project Structure

```text
iot-smart-home-security
│
├── architecture/
│   └── security_architecture.md
│
├── devices/
│   ├── sensor.py
│   ├── camera.py
│   └── smart_lock.py
│
├── firmware/
│   ├── firmware_v1.txt
│   └── firmware_hash.txt
│
├── monitoring/
│   └── monitor.py
│
├── security/
│   ├── auth.py
│   ├── encryption.py
│   ├── firmware_security.py
│   └── rbac.py
│
├── server/
│   └── subscriber.py
│
├── tests/
│   └── test_security.py
│
├── data/
│   └── encrypted_data.txt
│
├── logs/
│   └── activity.log
│
├── requirements.txt
├── setup_project.sh
├── .gitignore
└── README.md
```

---

# ⚙️ Installation

## 1. Clone the Repository

```bash
git clone https://github.com/Yuvrajbaisoya/iot-smart-home-security.git
```

```bash
cd iot-smart-home-security
```

---

## 2. Create a Virtual Environment

On Kali Linux or other systems using an externally managed Python environment:

```bash
python3 -m venv venv
```

Activate it:

```bash
source venv/bin/activate
```

---

## 3. Install Dependencies

```bash
pip install -r requirements.txt
```

Verify the installation:

```bash
python -c "import paho.mqtt.client; from cryptography.fernet import Fernet; print('Dependencies OK')"
```

Expected output:

```text
Dependencies OK
```

---

# 📡 MQTT Broker Setup

Install Mosquitto:

```bash
sudo apt install mosquitto mosquitto-clients -y
```

Enable and start the service:

```bash
sudo systemctl enable --now mosquitto
```

Check its status:

```bash
sudo systemctl status mosquitto --no-pager
```

The broker should display:

```text
Active: active (running)
```

---

# 🚀 Running the Project

Open multiple terminal windows.

Make sure the virtual environment is activated:

```bash
cd ~/iot-smart-home-security
source venv/bin/activate
```

---

## Terminal 1 — Start Secure Subscriber

```bash
python server/subscriber.py
```

Expected output:

```text
Connecting to MQTT Broker...
Connected to MQTT Broker
```

---

## Terminal 2 — Start Temperature Sensor

```bash
python devices/sensor.py
```

Example:

```text
Sensor simulator started...

Sensor Data Sent:
{
    "device_id": "sensor_001",
    "type": "temperature_sensor",
    "temperature": 30,
    "humidity": 70
}
```

---

## Terminal 3 — Start Smart Camera

```bash
python devices/camera.py
```

Example:

```text
Camera simulator started...

Camera Data Sent:
{
    "device_id": "camera_001",
    "type": "smart_camera",
    "motion": "detected",
    "status": "online"
}
```

---

## Terminal 4 — Start Smart Lock

```bash
python devices/smart_lock.py
```

Example:

```text
Smart Lock simulator started...

Lock Status Sent:
{
    "device_id": "lock_001",
    "type": "smart_lock",
    "status": "LOCKED"
}
```

---

## Terminal 5 — Start Security Monitoring

```bash
python monitoring/monitor.py
```

Expected:

```text
IoT Security Monitoring Started...
```

---

# 🧪 Security Tests

Run:

```bash
python tests/test_security.py
```

Example output:

```text
Running IoT Security Tests...

Valid authentication: True
Invalid authentication: False

Admin can manage devices: True
Guest can control lock: False
```

---

# 🧪 Testing Unknown Device Detection

Publish a simulated unauthorized device message:

```bash
mosquitto_pub \
-h localhost \
-t smarthome/unknown \
-m '{"device_id":"hacker_device_999","type":"unknown_sensor","status":"active"}'
```

The monitoring system should detect it:

```text
ALERT: Unknown Device Activity!

Topic=smarthome/unknown
Payload={"device_id":"hacker_device_999","type":"unknown_sensor","status":"active"}
```

---

# 🔄 Data Flow

```text
┌──────────────┐
│ IoT Devices  │
└──────┬───────┘
       │
       │ MQTT Messages
       ▼
┌──────────────┐
│ MQTT Broker  │
└──────┬───────┘
       │
       ▼
┌──────────────────┐
│ Secure Subscriber│
└──────┬───────────┘
       │
       ├──────────────► Activity Logging
       │
       ├──────────────► Data Encryption
       │
       └──────────────► Security Monitoring
```

---

# 🛡️ Security Concepts Demonstrated

* IoT Device Simulation
* MQTT Communication
* Device Authentication
* Role-Based Access Control
* Symmetric Data Encryption
* Firmware Integrity Verification
* SHA-256 Hashing
* Activity Logging
* Unknown Device Detection
* Basic Security Monitoring

---

# ⚠️ Security Limitations

This project is designed for **educational and research purposes**.

The current implementation demonstrates important security concepts but should not be considered production-ready.

Some limitations include:

* Credentials are currently stored directly in source code.
* MQTT communication is configured locally and does not currently use TLS.
* Firmware verification uses hash comparison rather than a full digital-signature-based secure boot system.
* Encryption key management is simplified for demonstration.
* Production systems should use secure credential storage and rotation.
* Certificate-based authentication should be considered.
* Hardware-backed key storage should be used where available.
* Real-world monitoring should include stronger anomaly detection and alerting mechanisms.

---

# 🔮 Future Improvements

Possible improvements include:

* [ ] MQTT over TLS
* [ ] Certificate-based device authentication
* [ ] Secure password hashing
* [ ] JWT-based authentication
* [ ] Digital firmware signatures
* [ ] Secure boot simulation
* [ ] Device anomaly detection
* [ ] Real-time security dashboard
* [ ] Database integration
* [ ] Docker deployment
* [ ] REST API for device management
* [ ] SIEM integration

---

# 👨‍💻 Author

**Yuvraj Baisoya**

Research Project — **First Quadrant Labs**

---

# 📚 Project Title

> **Securing Internet of Things (IoT) Devices in Smart Home Environments**

---

⭐ If you found this project useful, consider giving the repository a star!
