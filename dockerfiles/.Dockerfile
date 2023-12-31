FROM python:3.11.7-bookworm AS WEBAPP_BASE

ARG DEBIAN_FRONTEND=noninteractive

ENV VIRTUAL_ENV=/venv \
    PATH="/venv/bin:${PATH}"

RUN set -eux; env apt-get update; \
    apt-get install -y --no-install-recommends libpq5; \
    rm -rf /var/lib/apt/lists/*

FROM WEBAPP_BASE AS WEBAPP_BUILD

ARG DEBIAN_FRONTEND=noninteractive
ARG POETRY_VERSION=1.7.1

RUN set -eux; apt-get update; \
    apt-get install -y --no-install-recommends gcc libpq-dev python3-dev; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; python -m pip install "poetry==${POETRY_VERSION}"; \
    python -m venv /venv

WORKDIR /src

COPY pyproject.toml poetry.lock /src/

RUN poetry install --no-ansi --no-root --only=main

FROM WEBAPP_BASE

COPY --from=WEBAPP_BUILD /venv /venv

COPY ./src/sample ./sample

EXPOSE 8000

WORKDIR ./sample

CMD [ "gunicorn", "-b", "0.0.0.0:8000", "sample.wsgi" ]