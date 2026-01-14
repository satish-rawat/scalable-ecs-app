from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from celery.result import AsyncResult
from celery_init import celery_app
from tasks import process_data_task
from security import setup_security
from config import CeleryConfig
from schemas import TaskPayload, TaskResponse
from redis import Redis
from pydantic import BaseModel
from typing import List, Dict, Any

app = FastAPI(title="Scalable Parallel Processing Application")

# Apply security settings
setup_security(app)


@app.get("/", include_in_schema=False)
async def root():
    return RedirectResponse(url="/docs")


@app.get("/health")
async def health():
    # Check Celery workers and Redis availability
    redis_ok = False
    celery_ok = False
    redis_error = None
    try:
        r = Redis.from_url(CeleryConfig.broker_url)
        redis_ok = r.ping()
    except Exception as e:
        redis_error = str(e)

    try:
        resp = celery_app.control.ping(timeout=1.0)
        celery_ok = isinstance(resp, list)
    except Exception:
        celery_ok = False

    return {"redis": redis_ok, "celery": celery_ok, "redis_error": redis_error}


@app.post("/run-task", response_model=TaskResponse)
async def trigger_task(payload: TaskPayload):
    """Backward-compatible simple endpoint to submit a task."""
    task = process_data_task.delay(payload)
    return {"task_id": task.id, "status": "Processing"}

@app.get("/status/{task_id}")
async def get_status(task_id: str):
    result = AsyncResult(task_id, app=celery_app)
    return {"id": task_id, "state": result.state, "result": result.result}
