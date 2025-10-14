
from flask import request, jsonify
from .schemas import Operands, ValidationError
from .services import add, subtract, multiply, divide

def parse_operands():
    if request.method == "POST":
        payload = request.get_json(silent=True) or {}
        a = payload.get("a", None)
        b = payload.get("b", None)
    else:
        a = request.args.get("a", None)
        b = request.args.get("b", None)

    try:
        operands = Operands(a=a, b=b)
        return operands, None
    except ValidationError as ve:
        return None, (jsonify(error="validation_error", details=ve.errors()), 400)

def do_operation(op_name: str, fn):
    operands, err = parse_operands()
    if err:
        return err

    try:
        result = fn(operands.a, operands.b)
    except ZeroDivisionError as zde:
        return jsonify(error="math_error", message=str(zde)), 400
    except Exception as ex:
        return jsonify(error="internal_error", message=str(ex)), 500

    return jsonify(
        operation=op_name,
        a=operands.a,
        b=operands.b,
        result=result
    ), 200

def register_routes(app):
    @app.get("/add")
    @app.post("/add")
    def add_route():
        return do_operation("add", add)

    @app.get("/subtract")
    @app.post("/subtract")
    def subtract_route():
        return do_operation("subtract", subtract)

    @app.get("/multiply")
    @app.post("/multiply")
    def multiply_route():
        return do_operation("multiply", multiply)

    @app.get("/divide")
    @app.post("/divide")
    def divide_route():
        return do_operation("divide", divide)
