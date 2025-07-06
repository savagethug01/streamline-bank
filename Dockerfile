# Ensure mise compiles Python rather than using broken prebuilt versions
ARG MISE_SETTINGS_PYTHON_COMPILE=1
ENV MISE_SETTINGS_PYTHON_COMPILE=${MISE_SETTINGS_PYTHON_COMPILE}

# Base image
ARG PYTHON_VERSION=3.13-slim
FROM python:${PYTHON_VERSION}

# Environment setup
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install build dependencies for psycopg2 etc.
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
RUN mkdir -p /code
WORKDIR /code/BANK

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Copy the rest of the project
COPY . /code

# Expose Django/gunicorn port
EXPOSE 1641

# Start the app with gunicorn
CMD ["gunicorn", "--bind", ":1641", "--workers", "2", "BANK.wsgi"]
