from argparse import Namespace
from os import path as os_path
from pathlib import Path
from types import SimpleNamespace
from typing import Union

import pytest
from alembic.command import downgrade, upgrade
from alembic.config import Config
from alembic.script import Script, ScriptDirectory

from {{ cookiecutter.project_slug }}.config import settings

PROJECT_PATH = Path(__file__).parent.parent.parent.parent.resolve()


def make_alembic_config(cmd_opts: Union[Namespace, SimpleNamespace], base_path: Path = PROJECT_PATH) -> Config:
    """
    Создает объект конфигурации alembic на основе аргументов командной строки,
    подменяет относительные пути на абсолютные.
    """
    database_uri = settings.DATABASE_URL

    path_to_folder = cmd_opts.config
    # Подменяем путь до файла alembic.ini на абсолютный
    if not os_path.isabs(cmd_opts.config):
        cmd_opts.config = os_path.join(base_path, cmd_opts.config + "alembic.ini")

    config = Config(file_=cmd_opts.config, ini_section=cmd_opts.name, cmd_opts=cmd_opts)

    # Подменяем путь до папки с alembic на абсолютный
    alembic_location = config.get_main_option("script_location")
    if not os_path.isabs(alembic_location):
        config.set_main_option("script_location", os_path.join(base_path, path_to_folder + alembic_location))
    if cmd_opts.pg_url:
        config.set_main_option("sqlalchemy.url", database_uri)

    return config


def get_revisions():
    # Считывает конфигурацию alembic
    options = SimpleNamespace(config="./", name="alembic", pg_url=settings.TEST_DATABASE_URL, raiseerr=False, x=None)
    config = make_alembic_config(options)

    # Получает ревизии из директории
    revisions_dir = ScriptDirectory.from_config(config)
    revisions = list(revisions_dir.walk_revisions("base", "heads"))

    # Обращает порядок следования по ревизии
    revisions.reverse()
    return revisions


@pytest.mark.parametrize("revision", get_revisions())
def test_migrations_stairway(revision: Script):
    # Считывает конфигурацию alembic
    options = SimpleNamespace(config="./", name="alembic", pg_url=settings.TEST_DATABASE_URL, raiseerr=False, x=None)
    alembic_config = make_alembic_config(options)

    # Запускает тест ревизии
    upgrade(alembic_config, revision.revision)
    downgrade(alembic_config, revision.down_revision or "-1")  # -1 for first revision
    upgrade(alembic_config, revision.revision)
