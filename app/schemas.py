
from pydantic import BaseModel, ValidationError, field_validator
from typing import Any

class Operands(BaseModel):
    a: float
    b: float

    @field_validator('a', 'b', mode='before')
    @classmethod
    def ensure_number(cls, v: Any):
        try:
            return float(v)
        except (TypeError, ValueError):
            raise ValueError("Value must be a number")
