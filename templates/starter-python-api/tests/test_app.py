from fastapi.testclient import TestClient
from src.app import app, add

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"ok": True}

def test_add():
    assert add(2, 2) == 4
