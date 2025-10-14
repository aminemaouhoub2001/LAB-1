Objectifs du LAB

Ce projet DevOps comporte 7 étapes principales :

Création d'une API Python permettant des opérations arithmétiques (add, subtract, multiply, divide).

Mise en place d’un script PowerShell pour surveiller les changements locaux dans le code.

Automatisation de la reconstruction de l’image Docker à chaque modification détectée.

Déploiement automatique du conteneur Docker.

Gestion du code source avec Git et mise en ligne sur GitHub.

Détection automatique des nouveaux commits distants (GitHub) et mise à jour via git_pull.

Tag et publication de l’image Docker sur Docker Hub.

---

## 🔧 Étape 1 – API Python (Flask)

L’API expose des endpoints REST simples :

| Opération | Endpoint | Exemple |
|------------|----------|----------|
| Addition | `/add?a=2&b=3` | → 5 |
| Soustraction | `/subtract?a=5&b=2` | → 3 |
| Multiplication | `/multiply?a=3&b=4` | → 12 |
| Division | `/divide?a=10&b=2` | → 5 |

Fichier principal : `wsgi.py` + dossier `app/`.

---

## 🐳 Étape 2, 3 et 4 – Docker + Automatisation locale

### Dockerfile
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "wsgi:app"]
