import os
from flask import Flask

app = Flask(__name__)

# Fetch the secret value from the environment variable
secret_key = os.getenv('in-pod-expose')


@app.route('/')
def home():
    return f"Secret Key: {secret_key}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


