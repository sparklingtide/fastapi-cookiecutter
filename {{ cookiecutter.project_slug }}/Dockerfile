FROM python:3.11-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
WORKDIR /app

RUN apt-get update && \
    apt-get install -y build-essential libpq-dev gettext libmagic-dev libjpeg-dev zlib1g-dev && \
    apt-get purge -y --auto-remove -o APT:AutoRemove:RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

RUN poetry config virtualenvs.create false

COPY ./pyproject.toml ./poetry.lock /app/
RUN poetry install --no-root --only main

COPY ./ /app/

CMD [ "python", "main.py" ]
