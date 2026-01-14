import os
from kombu import Queue

class CeleryConfig:
    # Use environment variables with local fallbacks
    broker_url = os.getenv("REDIS_URL", "redis://localhost:6379/0")
    result_backend = os.getenv("REDIS_URL", "redis://localhost:6379/0")
    
    task_queues = (
        Queue('default', routing_key='default'),
        Queue('aws_queue', routing_key='aws.#'),
        Queue('gcp_queue', routing_key='gcp.#'),
    )
    task_default_queue = 'default'

    # 2. Beat Schedule - Periodic DevOps Cleanups
    beat_schedule = {
        'cleanup-aws-temp-files-every-hour': {
            'task': 'src.tasks.aws_cleanup_task',
            'schedule': 3600.0, # seconds
            'options': {'queue': 'aws_queue'}
        },
        'sync-gcp-inventory-daily': {
            'task': 'src.tasks.gcp_sync_task',
            'schedule': 86400.0,
            'options': {'queue': 'gcp_queue'}
        },
    }

    # Task execution settings
    task_serializer = 'json'
    result_serializer = 'json'
    accept_content = ['json']
    timezone = 'UTC'
    enable_utc = True
    # 1. Reliability: Task is acknowledged AFTER completion. 
    # If the worker crashes mid-task, Redis keeps it and re-delivers it.
    task_acks_late = True
    # 2. Hard Time Limit: Force-kill the task after X seconds (e.g., 300s).
    task_time_limit = 300 
    # 3. Soft Time Limit: Raises a SoftTimeLimitExceeded exception.
    task_soft_time_limit = 240

    # 4. Worker Protection: Ensure the worker doesn't leak memory
    worker_max_tasks_per_child = 100
    # Security: Task result expiry (e.g., 1 hour)
    result_expires = 3600
