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


if __name__ == "__main__":
    generate_key()

    original_data = "Smart Home Sensor Data"

    encrypted = encrypt_data(original_data)

    decrypted = decrypt_data(encrypted)

    print("Original:", original_data)
    print("Encrypted:", encrypted)
    print("Decrypted:", decrypted)
