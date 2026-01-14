from celery import Celery
from config import CeleryConfig

# The 'celery_app' instance is created here once
celery_app = Celery("worker")
celery_app.config_from_object(CeleryConfig)

# This ensures Celery finds your tasks
# Support both package-style import 'src.tasks' and flat 'tasks' depending on how the app is started
celery_app.autodiscover_tasks(['src.tasks', 'tasks'])
