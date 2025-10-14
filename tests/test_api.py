
import json
from app import create_app

def client():
    app = create_app()
    app.testing = True
    return app.test_client()

def test_health():
    c = client()
    resp = c.get("/health")
    assert resp.status_code == 200
    assert resp.get_json()["status"] == "ok"

def test_add_post():
    c = client()
    resp = c.post("/add", json={"a": 2, "b": 3})
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["result"] == 5

def test_add_get_params():
    c = client()
    resp = c.get("/add?a=2&b=3")
    assert resp.status_code == 200
    assert resp.get_json()["result"] == 5

def test_divide_by_zero():
    c = client()
    resp = c.post("/divide", json={"a": 2, "b": 0})
    assert resp.status_code == 400
    data = resp.get_json()
    assert data["error"] == "math_error"
