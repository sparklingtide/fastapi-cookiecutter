FastAPI Cookiecutter
===================
![Build Status](https://github.com/sparklingtide/fastapi-cookiecutter/actions/workflows/main.yaml/badge.svg)

Powered by [Cookiecutter](https://github.com/audreyr/cookiecutter), Cookiecutter FastAPI is a framework for jumpstarting production-ready FastAPI projects quickly

## Features

* Full setup [FastAPI](https://fastapi.tiangolo.com/) application
* [SQLAlchemy](https://www.sqlalchemy.org/) with asyncpg driver and [Alembic](https://alembic.sqlalchemy.org/) for migrations
* Manage virtual environments with [Poetry](https://python-poetry.org/)
* Basic [Helm](https://helm.sh/) chart to deploy into Kubernetes 

## Usage

First, get Cookiecutter:

    $ pip install cookiecutter

Now run it against this repo:

    $ cookiecutter https://github.com/sparklingtide/fastapi-cookiecutter

You'll be prompted for some values. Provide them, then a FastAPI project will be created for you.

Happy hacking!!!
