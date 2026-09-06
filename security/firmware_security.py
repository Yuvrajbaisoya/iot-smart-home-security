import hashlib
import os

PROJECT_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..")
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
    firmware_hash = calculate_hash(FIRMWARE_FILE)

    with open(HASH_FILE, "w") as file:
        file.write(firmware_hash)

    print("\nFirmware integrity hash created:")
    print(firmware_hash)


def verify_firmware():
    if not os.path.exists(HASH_FILE):
        print("Firmware hash not found.")
        return

    current_hash = calculate_hash(FIRMWARE_FILE)

    with open(HASH_FILE, "r") as file:
        original_hash = file.read().strip()

    if current_hash == original_hash:
        print("\nFirmware VERIFIED")
        print("Integrity check passed.")
    else:
        print("\nWARNING: Firmware MODIFIED!")
        print("Installation BLOCKED.")


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
