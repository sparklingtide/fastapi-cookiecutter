from typing import TypeVar

import orjson
from pydantic import BaseModel as PydanticModel

DataT = TypeVar("DataT")


def orjson_dumps(v, *, default):
    # orjson.dumps returns bytes, to match standard json.dumps we need to decode
    return orjson.dumps(v, default=default).decode()


def to_camel_case(snake_str: str) -> str:
    components = snake_str.split("_")
    return components[0] + "".join(x.title() for x in components[1:])


class BaseModel(PydanticModel):
    class Config:
        json_loads = orjson.loads
        json_dumps = orjson_dumps
        alias_generator = to_camel_case
        orm_mode = True
        allow_population_by_field_name = True
