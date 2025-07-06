FROM python:3.12-slim

WORKDIR /app

# Install build dependencies for compiling Python
RUN apt-get update && apt-get install -y \
    curl git build-essential zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev ca-certificates xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install mise and force Python build
RUN curl https://mise.run | sh && \
    export PATH="/root/.local/share/mise/bin:/root/.local/share/mise/shims:$PATH" && \
    /root/.local/share/mise/bin/mise settings set python_compile 1 && \
    /root/.local/share/mise/bin/mise use -g python@3.12

# Add mise to global PATH
ENV PATH="/root/.local/share/mise/bin:/root/.local/share/mise/shims:$PATH"

COPY . .

RUN chmod +x /app/setup.sh && bash /app/setup.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8090

CMD ["/app/entrypoint.sh"]
