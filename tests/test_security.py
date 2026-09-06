import sys
import os

PROJECT_DIR = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        ".."
    )
)

sys.path.append(PROJECT_DIR)

from security.auth import authenticate_device
from security.rbac import check_permission


print("Running IoT Security Tests...\n")

print(
    "Valid authentication:",
    authenticate_device(
        "sensor_001",
        "sensor_user",
        "sensor_pass_123"
    )
)

print(
    "Invalid authentication:",
    authenticate_device(
        "sensor_001",
        "wrong_user",
        "wrong_password"
    )
)

print(
    "Admin can manage devices:",
    check_permission(
        "admin",
        "manage_devices"
    )
)

print(
    "Guest can control lock:",
    check_permission(
        "guest",
        "control_lock"
    )
)
