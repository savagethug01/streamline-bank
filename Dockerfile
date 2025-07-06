ARG MISE_SETTINGS_PYTHON_COMPILE=1
ENV MISE_SETTINGS_PYTHON_COMPILE=${MISE_SETTINGS_PYTHON_COMPILE}

ARG PYTHON_VERSION=3.13-slim
FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /code
WORKDIR /code/BANK

COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

COPY . /code

EXPOSE 1641

CMD ["gunicorn", "--bind", ":1641", "--workers", "2", "BANK.wsgi"]
