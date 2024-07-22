# ビルドには公式のPythonイメージslim版を使用
FROM python:3.11.9-slim-bookworm AS base
WORKDIR /usr/src/app
ENV PATH /root/.local/bin:$PATH

RUN apt-get -y update && \
    apt-get -y dist-upgrade

FROM base AS build

RUN apt-get -y install --no-install-recommends \
    curl && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config virtualenvs.create false

# キャッシュを効かせるためにpyproject.tomlだけ先にコピー
COPY ./app/pyproject.toml /usr/src/app/pyproject.toml

RUN poetry install --no-dev

FROM base AS develop

RUN apt-get -y install --no-install-recommends \
    git && \
    apt-get autoclean -y && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

COPY --from=build /root/.local /root/.local
COPY --from=build /root/.config /root/.config
COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin

# キャッシュを効かせるためにpyproject.tomlだけ先にコピー
COPY ./app/pyproject.toml /usr/src/app/pyproject.toml
RUN poetry install

COPY ./ /usr/src/

# 実行はpythonのdistrolessイメージを使用
FROM gcr.io/distroless/python3-debian12:latest AS production
WORKDIR /usr/src/app

ENV PYTHONPATH=/usr/lib/python3.11/site-packages:$PYTHONPATH

# bulid stageからコピー
COPY --from=build /usr/local/lib/python3.11/site-packages /usr/lib/python3.11/site-packages
COPY --from=build /usr/local/bin /usr/local/bin
COPY --chown=nonroot:nonroot ./app /usr/src/app

USER nonroot

CMD ["/usr/local/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
