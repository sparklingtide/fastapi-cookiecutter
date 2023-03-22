import logging

import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import {{ cookiecutter.project_slug }}.app.healthcheck.controllers as healthcheck
from {{ cookiecutter.project_slug }}.config import settings

logger = logging.getLogger(__name__)

app = FastAPI(docs_url="/api/docs", openapi_url="/api/openapi.json", redoc_url=None)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(healthcheck.router, tags=["healthcheck"])

if __name__ == "__main__":
    uvicorn.run(app, host=settings.SERVER_HOST, port=settings.SERVER_PORT)
