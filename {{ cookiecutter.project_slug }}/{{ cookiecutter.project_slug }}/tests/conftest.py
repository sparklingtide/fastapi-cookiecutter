from asyncio import get_event_loop_policy

import pytest
import pytest_asyncio
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from main import app
from {{ cookiecutter.project_slug }}.config import settings
from {{ cookiecutter.project_slug }}.db import Base


@pytest.fixture(scope="session")
def event_loop():
    policy = get_event_loop_policy()
    loop = policy.new_event_loop()
    yield loop
    loop.close()


# Replaces db connection with a connection to the test db
engine = create_async_engine(settings.TEST_DATABASE_URL, echo=True, future=True)


@pytest_asyncio.fixture
async def prepare_db():
    # Clears previous tables in db and creates new ones
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
        await conn.commit()
        yield


@pytest_asyncio.fixture
async def async_session(prepare_db) -> AsyncSession:
    session_maker = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    async with session_maker() as session:
        yield session


@pytest.fixture
def client() -> AsyncClient:
    yield AsyncClient(app=app, base_url="http://test")


# TODO: переписать stairway тест через engine
