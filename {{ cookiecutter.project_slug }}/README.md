# {{ cookiecutter.project_name }}

## Развертывание dev-окружения на чистую систему

1. Необходим установленный python3.11, для управления зависимостями используется [poetry](https://python-poetry.org/docs/#installation)
2. poetry стоит настроить на установку виртуального окружения прямо в проекте
   ```shell
   $ poetry config virtualenvs.in-project true
   # необязательная настройка, которая поможет в случае, если проект будет также запускаться в docker-контейнере
   # позволяет использовать приложению в контейнере то же самое виртуальное окружение
   # не требуется, если приложение не планируется запускаться локально в контейнере
   $ poetry config virtualenvs.options.always-copy true
   ```

3. ```shell
    poetry install --no-root
    poetry shell
    ```

4. Так же необходимо установить и настроить PostgreSQL (предпочтительная версия — 15.2). В PostgreSQL требуется создать БД с именем app, и установить пароль для пользователя postgres "postgres" (все значения можно отредактировать в переменных среды, например, через файл `.env`, доступные переменные для редактирования — в файле `.env.example`).

5. ```shell
    pre-commit install
    ```

### Развертывание через docker-compose

```shell
    pre-commit install
    make compose-up
    make compose-enter
    poetry install --no-root
```

Для остановки окружения:

```shell
    make compose-down
```

`make compose-enter` открывает новый шелл внутри app-контейнера (например, для миграций)

### Развертывание через VSCode

1. Установить расширение Remote Containers
2. `Ctrl-shift-P` для запуска Command Pallette
3. Выбрать `Remote-Containers: Reopen in Container`

## Структура проекта

Используется паттерн MVC
Приложение монолитное, разбито на компоненты.

```structure
{{ cookiecutter.project_slug }}
    component_name
    │   controllers - Эндпоинты
    │   views - Входные и выходные модели эндпоинтов
    |   models - БД модели
    │
    db - модуль работы с БД
    models - работа с моделями БД
    tests - автотесты
    config.py - настройки проекта (.env файл)
    protocol.py - входные, выходные модели данных, базовая модель pydantic
```

## Стек проекта

* PostgreSQL (SQLAlchemy)
* FastAPI

## Строка подключения к БД

"postgresql+asyncpg://scott:tiger@localhost/test"

## Запуск миграций

```shell
    alembic upgrade head
```
