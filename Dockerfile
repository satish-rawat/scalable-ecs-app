FROM python:3.10-slim

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

WORKDIR /app

# Install system dependencies if any are needed for Redis/Celery
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY ./src .

# Ensure the script is executable
RUN chmod +x /app/run.sh
# Security: Create and switch to a non-root user
RUN useradd -m custom_user && chown -R custom_user:custom_user /app
USER custom_user



# Default to API if no WORKER_TYPE is provided
ENV WORKER_TYPE=api
EXPOSE 8000 5555
ENTRYPOINT ["/app/run.sh"]