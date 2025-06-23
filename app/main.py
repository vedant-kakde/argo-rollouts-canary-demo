from fastapi import FastAPI
import os
from prometheus_client import start_http_server, Counter
import threading

app = FastAPI()
version = os.getenv("APP_VERSION", "v1")
REQUEST_COUNT = Counter("http_requests_total", "Total HTTP requests", ["version"])

@app.get("/")
def root():
    REQUEST_COUNT.labels(version=version).inc()
    return {"message": f"Hello from {version}"}

@app.get("/health")
def health():
    return {"status": "ok"}

# Start Prometheus metrics server
threading.Thread(target=start_http_server, args=(8001,), daemon=True).start()
