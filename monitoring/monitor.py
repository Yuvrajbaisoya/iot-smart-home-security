import os
import time

PROJECT_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
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
