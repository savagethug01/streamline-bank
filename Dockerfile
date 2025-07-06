# force mise to compile python instead of using broken prebuilt archives
ARG MISE_SETTINGS_PYTHON_COMPILE=1
ENV MISE_SETTINGS_PYTHON_COMPILE=${MISE_SETTINGS_PYTHON_COMPILE}

# rest of your Dockerfile
ARG PYTHON_VERSION=3.13-slim
FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install psycopg2 dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
RUN mkdir -p /code
WORKDIR /code

# Install dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Copy project
COPY . /code

# Don't collectstatic at build — do it after deploy
# RUN python manage.py collectstatic --noinput  ❌ REMOVE THIS

# Don't hardcode SECRET_KEY here
# ENV SECRET_KEY "..." ❌ REMOVE THIS

EXPOSE 1641

# Run with Gunicorn
CMD ["gunicorn", "--bind", ":1641", "--workers", "2", "BANK.wsgi"]
