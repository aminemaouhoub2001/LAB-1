
from flask import Flask, jsonify, render_template
from .api import register_routes

def create_app():
    app = Flask(__name__)

  
    register_routes(app)

   
    @app.get("/health")
    def health():
        return jsonify(status="ok", service="arithmetics-api"), 200

 
    @app.get("/")
    def index():
        return jsonify(message="Arithmetic API – Flask"), 200

   
    @app.get("/calculator")
    def calculator():
        return render_template("calculator.html")

    return app
