from celery import shared_task

@shared_task(bind=True, 
             max_retries=3, 
             retry_backoff=True,
             retry_backoff_max=600,
             retry_jitter=True,
             name="process_data_task",
             queue="default")
def process_data_task(self, data: dict):
    try:
        # AWS/GCP Logic goes here
        return {"status": "success", "data": data}
    except Exception as exc:
        raise self.retry(exc=exc, countdown=60)