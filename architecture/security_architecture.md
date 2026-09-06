# IoT Security Architecture

## Overview

This project demonstrates a security framework for IoT devices in a smart home environment.

## Components

### IoT Devices

The simulated environment contains:

- Temperature Sensor
- Smart Camera
- Smart Lock

Each device sends data using MQTT.

## Security Layers

### 1. Authentication

Devices are validated using registered device credentials.

### 2. Authorization

Role-Based Access Control (RBAC) restricts actions based on user roles.

Roles include:

- Admin
- Owner
- Guest

### 3. Data Encryption

Device data is encrypted before storage using the Python cryptography library.

### 4. Firmware Integrity

Firmware integrity is checked using SHA-256 hashes.

If the firmware hash changes, verification fails.

### 5. Monitoring

The monitoring module watches activity logs and detects unknown device activity.

## Data Flow

IoT Device
    |
    | MQTT
    v
MQTT Broker
    |
    v
Secure Subscriber
    |
    +--> Activity Logging
    |
    +--> Encrypted Storage
    |
    +--> Security Monitoring
