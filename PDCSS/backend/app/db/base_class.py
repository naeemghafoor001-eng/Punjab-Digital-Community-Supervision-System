from typing import Any
from sqlalchemy.orm import declarative_base, declared_attr

class CustomBase:
    id: Any
    __name__: str

    # Automatically generate table name from class name if not specified
    @declared_attr
    def __tablename__(cls) -> str:
        return cls.__name__.lower() + "s"

Base = declarative_base(cls=CustomBase)
