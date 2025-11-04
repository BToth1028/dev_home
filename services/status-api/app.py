from flask import Flask, jsonify
import os
import time

app = Flask(__name__)


@app.get("/health")
def health():
    return jsonify(status="ok", ts=int(time.time())), 200


@app.get("/ready")
def ready():
    return jsonify(ready=True), 200


@app.get("/")
def index():
    return jsonify(service="status-api", version="1.0.0", endpoints=["/health", "/ready"]), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5050))
    app.run(host="0.0.0.0", port=port, debug=True)
