import os
import psycopg
from fastapi import FastAPI
from .path_helper import DATA_DIR, LOG_DIR, CACHE_DIR

app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True}

@app.get("/db/ping")
def db_ping():
    url = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@db:5432/postgres")
    try:
        with psycopg.connect(url, connect_timeout=3) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                val = cur.fetchone()[0]
        return {"ok": True, "select": val}
    except Exception as e:
        return {"ok": False, "error": str(e)}

def add(a, b):
    return a + b
