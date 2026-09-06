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
