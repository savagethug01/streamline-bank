# Base image
ARG PYTHON_VERSION=3.13-slim
FROM python:${PYTHON_VERSION}

# Ensure mise compiles Python rather than using broken prebuilt versions
ARG MISE_SETTINGS_PYTHON_COMPILE=1
ENV MISE_SETTINGS_PYTHON_COMPILE=${MISE_SETTINGS_PYTHON_COMPILE}

# Environment setup
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies (e.g., for psycopg2)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
RUN mkdir -p /code
WORKDIR /code/BANK

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Copy project source
COPY . /code

# Copy release script and make it executable
COPY release.sh /code/BANK/release.sh
RUN chmod +x /code/BANK/release.sh

# Expose Django/gunicorn port
EXPOSE 1641

# Start Gunicorn server
CMD ["gunicorn", "--bind", ":1641", "--workers", "2", "BANK.wsgi"]
