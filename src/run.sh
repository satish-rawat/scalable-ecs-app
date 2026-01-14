#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "Starting service for WORKER_TYPE: ${WORKER_TYPE:-api}"

case "${WORKER_TYPE}" in
  "api")
    # Start FastAPI for the web/hub
    exec uvicorn views:app --host 0.0.0.0 --port 8000
    ;;

  "hub_worker")
    # Standard worker for general tasks
    exec celery -A celery_init.celery_app worker -Q default -l info
    ;;

  "processing_worker")
    # Specialized worker for heavy cloud processing (AWS/GCP)
    exec celery -A celery_init.celery_app worker -Q aws_queue,gcp_queue -l info --concurrency=4
    ;;

  "beat_worker")
    # Scheduler for periodic tasks
    exec celery -A celery_init.celery_app beat -l info
    ;;

  "flower_worker")
    # Monitoring dashboard
    exec celery -A celery_init.celery_app flower --port=5555
    ;;

  *)
    echo "Error: Unknown WORKER_TYPE '${WORKER_TYPE}'"
    exit 1
    ;;
esac