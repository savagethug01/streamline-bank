# Use official slim Python image
FROM python:3.11-slim

# Set environment variables to improve performance and disable prompts
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    DJANGO_SUPPRESS_PROMPTS=true

# Set working directory
WORKDIR /app

# Install system dependencies for building Python packages and PostgreSQL support
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the entire Django project
COPY . .

# Ensure static files are collected
RUN python manage.py collectstatic --no-input

# Ensure the entrypoint script is executable
RUN chmod +x /app/entrypoint.sh

# Expose the port used by Django dev server
EXPOSE 8090

# Set the default command to run the app
ENTRYPOINT ["/app/entrypoint.sh"]
