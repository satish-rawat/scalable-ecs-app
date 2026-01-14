celery -A celery_init worker -Q default --loglevel=info
python3 -m uvicorn src.views:app --reload

## API Endpoints (FastAPI)

- GET /docs - OpenAPI docs
- GET /health - Health checks (Redis + Celery)
- POST /run-task - Simple single task submit (legacy)
- POST /tasks - Submit a single task (JSON: {"payload": {...}}), use query `task_type=heavy` for heavy task
- POST /tasks/batch - Submit many tasks (JSON: {"payloads": [...], "task_type": "process"})
- GET /tasks/{task_id} - Task status and result
- POST /tasks/{task_id}/revoke - Revoke/terminate a task
- GET /queues - Approximate queue lengths and active consumer info

## Running locally (recommended)

A quick way to run Redis + API + workers for development is using Docker Compose:

```bash
docker-compose up --build
```
Running in Individual Terminal
```bash
celery -A celery_init worker -Q default --loglevel=info
python3 -m uvicorn src.views:app --reload
```

This will start Redis, the API server (port 8000), Flower (5555) and worker containers. The API docs are available at http://localhost:8000/docs
