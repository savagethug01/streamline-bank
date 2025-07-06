# Use official Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install dependencies for building Python (needed if you use `python_compile = 1`)
RUN apt-get update && apt-get install -y \
    curl git build-essential zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev ca-certificates xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install mise
RUN curl https://mise.run | sh

# Set PATH for mise
ENV PATH="/root/.local/share/mise/bin:/root/.local/share/mise/shims:$PATH"

# Configure mise to build Python from source (avoid corrupt precompiled archive)
RUN mise settings set python_compile 1

# Optionally install a specific Python version via mise (e.g. if switching from 3.12 to another)
# RUN mise use -g python@3.12

# Copy project files
COPY . .

# Run setup script
RUN chmod +x /app/setup.sh
RUN bash /app/setup.sh

# Make entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Expose Django port
EXPOSE 8090

# Use entrypoint.sh to run commands
CMD ["/app/entrypoint.sh"]



