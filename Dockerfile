# Use official Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

COPY . .

RUN chmod +x /app/setup.sh
RUN bash /app/setup.sh


# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Expose Django port
EXPOSE 8090

# Use entrypoint.sh to run commands
CMD ["/app/entrypoint.sh"]


