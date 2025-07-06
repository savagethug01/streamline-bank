FROM python:3.12-slim

WORKDIR /app

# Install build dependencies (needed for some Python packages and mise-managed tools)
RUN apt-get update && apt-get install -y \
    curl git build-essential zlib1g-dev libssl-dev libbz2-dev libreadline-dev \
    libsqlite3-dev ca-certificates xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install mise (optional — only keep if you’re using it for tools like node, poetry, etc.)
RUN curl https://mise.run | sh

# Add mise to PATH
ENV PATH="/root/.local/share/mise/bin:/root/.local/share/mise/shims:$PATH"

# Disable Python installation via mise (since python is already installed via base image)
RUN echo "python disable" >> /root/.tool-versions

# Copy project files
COPY . .

# Run setup script
RUN chmod +x /app/setup.sh && bash /app/setup.sh

# Make entrypoint executable
RUN chmod +x /app/entrypoint.sh

# Expose Django development server port
EXPOSE 8090

# Use entrypoint to run Django
CMD ["/app/entrypoint.sh"]
