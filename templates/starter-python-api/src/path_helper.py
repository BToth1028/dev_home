import os
from pathlib import Path

def ensure_dir(env_var: str, default: str) -> Path:
    p = Path(os.getenv(env_var, default)).expanduser()
    p.mkdir(parents=True, exist_ok=True)
    return p

DATA_DIR = ensure_dir("APP_DATA_DIR", "~/.local/share/starter-python-api")
LOG_DIR  = ensure_dir("APP_LOG_DIR",  "~/.cache/starter-python-api/logs")
CACHE_DIR= ensure_dir("APP_CACHE_DIR","~/.cache/starter-python-api")
