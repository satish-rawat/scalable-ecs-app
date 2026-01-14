from pydantic import BaseModel
from typing import Any, Dict, List, Optional

class TaskPayload(BaseModel):
    payload: Dict[str, Any]

class BatchPayload(BaseModel):
    payloads: List[Dict[str, Any]]
    task_type: Optional[str] = "process"
    queue: Optional[str] = None

class TaskResponse(BaseModel):
    task_id: str
    status: str