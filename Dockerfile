FROM python:3.12-slim AS base
ENV PIP_NO_CACHE_DIR=1 PIP_DISABLE_PIP_VERSION_CHECK=1
RUN pip install --no-cache-dir pipenv
WORKDIR /app
COPY Pipfile Pipfile.lock ./

FROM base AS deps-prod
RUN PIPENV_NOSPIN=1 pipenv install --system --deploy \
    && pip uninstall pipenv -y

FROM base AS deps-dev
RUN PIPENV_NOSPIN=1 pipenv install --system --deploy --dev

FROM deps-dev AS test
COPY src ./src
COPY tests ./tests
ENV PYTHONPATH=/app
RUN pytest -q

FROM python:3.12-slim AS runtime
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY --from=deps-prod /usr/local /usr/local
COPY src ./src
CMD ["python", "-m", "src.main"]
