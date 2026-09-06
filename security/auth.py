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
