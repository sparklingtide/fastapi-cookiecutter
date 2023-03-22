from sqlalchemy import Column, Integer
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy.orm import declarative_base

from {{ cookiecutter.project_slug }}.config import settings

engine = create_async_engine(settings.DATABASE_URL, echo=True, future=True)

Base = declarative_base()


class BaseModel(Base):
    __abstract__ = True
    id = Column(Integer, primary_key=True)
