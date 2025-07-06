# Use official Python image
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl git build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget llvm libncursesw5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev \
    liblzma-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install mise
RUN curl https://mise.run | sh
ENV PATH="/root/.local/share/mise/shims:/root/.local/share/mise/bin:$PATH"

# Fix: Force source build of Python to avoid .tar.zst errors
RUN mise settings set python_compile 1
RUN mise use -g python@3.12

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Run setup
RUN chmod +x /app/setup.sh
RUN bash /app/setup.sh

# Make entrypoint executable
RUN chmod +x /app/entrypoint.sh

# Expose Django port
EXPOSE 8090

# Launch app
CMD ["/app/entrypoint.sh"]
