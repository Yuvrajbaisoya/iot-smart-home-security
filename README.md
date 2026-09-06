# Securing IoT Devices in Smart Home Environments

A research and implementation project demonstrating a security framework for Internet of Things (IoT) devices in a smart home environment.

## Project Overview

This project simulates multiple smart home IoT devices and demonstrates several important security concepts.

The simulated devices include:

- Temperature Sensor
- Smart Camera
- Smart Lock

The devices communicate through an MQTT broker. A secure subscriber receives device messages, logs activity, and stores received data in encrypted form.

## Security Features

### Device Authentication

Registered IoT devices are validated using device credentials.

### Role-Based Access Control

The project implements RBAC with the following roles:

- Admin
- Owner
- Guest

Permissions are restricted according to the assigned role.

### Data Encryption

Device data is encrypted before being stored.

### Firmware Integrity Verification

Firmware integrity is verified using SHA-256 hashing.

If the firmware file is modified after its reference hash is generated, the verification process detects the change.

### Activity Monitoring

The monitoring module checks device activity logs and alerts when activity does not match known devices.

### MQTT Communication

Simulated IoT devices communicate using MQTT topics.

## Project Architecture

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
    +--> Security Monitoring
```

## Project Structure

```text
iot-smart-home-security/

├── devices/
│   ├── sensor.py
│   ├── camera.py
│   └── smart_lock.py
│
├── security/
│   ├── auth.py
│   ├── rbac.py
│   ├── encryption.py
│   └── firmware_security.py
│
├── server/
│   └── subscriber.py
│
├── monitoring/
│   └── monitor.py
│
├── firmware/
│   └── firmware_v1.txt
│
├── tests/
│   └── test_security.py
│
├── architecture/
│   └── security_architecture.md
│
├── data/
├── logs/
├── requirements.txt
└── README.md
```

## Installation

Install Python dependencies:

```bash
pip3 install -r requirements.txt
```

Install Mosquitto MQTT broker:

```bash
sudo apt install mosquitto mosquitto-clients -y
```

Start the MQTT broker:

```bash
sudo systemctl start mosquitto
```

## Running Security Tests

```bash
python3 tests/test_security.py
```

Expected results:

```text
Valid authentication: True
Invalid authentication: False
Admin can manage devices: True
Guest can control lock: False
```

## Running Firmware Integrity Verification

```bash
python3 security/firmware_security.py
```

Choose option `1` to generate the firmware integrity hash.

Run the program again and choose option `2` to verify the firmware.

## Running the Project

Start the secure subscriber:

```bash
python3 server/subscriber.py
```

Open separate terminals and start the simulated devices:

```bash
python3 devices/sensor.py
```

```bash
python3 devices/camera.py
```

```bash
python3 devices/smart_lock.py
```

Start the monitoring system:

```bash
python3 monitoring/monitor.py
```

## Security Concepts Demonstrated

- IoT Device Simulation
- MQTT Communication
- Device Authentication
- Role-Based Access Control
- Encrypted Data Storage
- Firmware Integrity Verification
- Activity Logging
- Unknown Device Detection
- Basic Security Monitoring

## Important Note

This project is an educational and research demonstration.

The firmware integrity implementation demonstrates SHA-256 hash verification and should not be considered a complete production secure-boot or firmware code-signing system.

The encryption module is designed for demonstration purposes. Production systems should use proper key management, authenticated encryption, certificate-based authentication, and hardware-backed security where appropriate.

## Author

Yuvraj Baisoya

## Research Project

First Quadrant Labs

## Project Title

Securing Internet of Things (IoT) Devices in Smart Home Environments
