
# DevOps Lab – Arithmetic API (Flask)

API Python (Flask) propre et structurée pour effectuer les opérations arithmétiques de base :
**addition, soustraction, multiplication, division**.

- Validation des entrées avec Pydantic.
- Architecture modulaire (services / schemas / routes).
- Tests automatiques (pytest).
- Prête pour CI/CD et conteneurisation (Dockerfile + Gunicorn).
- **UI web (Flask template)** pour tester facilement : `/calculator`

## Installation (local)

```bash
python -m venv .venv
. .venv/Scripts/activate  # Windows
pip install -r requirements.txt
```

## Lancement

```bash
python wsgi.py
# http://127.0.0.1:5000
# Interface web: http://127.0.0.1:5000/calculator
```

## Endpoints

- `GET /health`
- `GET /`
- `POST/GET /add`
- `POST/GET /subtract`
- `POST/GET /multiply`
- `POST/GET /divide`

## Tests

```bash
pytest -q
```

## Docker (production)

```bash
docker build -t arithmetics-api:latest .
docker run -p 8000:8000 arithmetics-api:latest
# http://127.0.0.1:8000
```
