# Sample Services

Reference implementations demonstrating health endpoints and service patterns.

## Overview

These are **examples** to show how to implement health checks, OTEL instrumentation, and service patterns. Copy these patterns into your templates or actual services.

## Services

### status-api (Python)
Flask service with health endpoints.

**Run:**
```powershell
cd status-api
..\..\..venv\Scripts\pip install -r requirements.txt
..\..\..venv\Scripts\python app.py
```

**Test:**
```powershell
curl http://localhost:5050/health
curl http://localhost:5050/ready
curl http://localhost:5050/
```

**Endpoints:**
- `GET /` - Service info
- `GET /health` - Health check (returns 200 OK)
- `GET /ready` - Readiness check

**Production:**
```bash
gunicorn -w 2 -b 0.0.0.0:5050 wsgi:app
```

### status-node (Node.js)
Express service with health endpoints.

**Run:**
```powershell
cd status-node
npm install
npm start
```

**Test:**
```powershell
curl http://localhost:5051/health
curl http://localhost:5051/ready
curl http://localhost:5051/
```

**Endpoints:**
- `GET /` - Service info
- `GET /health` - Health check (returns 200 OK)
- `GET /ready` - Readiness check

## Patterns to Copy

### Health Endpoints

Every service should expose:
- `/health` - Liveness (is the process running?)
- `/ready` - Readiness (can it handle requests?)

Return JSON with timestamp:
```json
{
  "status": "ok",
  "ts": 1698012345
}
```

### OTEL Instrumentation

Both examples include OpenTelemetry dependencies. Wire up tracing with:

**Python:**
```python
from opentelemetry import trace
from opentelemetry.instrumentation.flask import FlaskInstrumentor

FlaskInstrumentor().instrument_app(app)
```

**Node:**
```javascript
import { NodeSDK } from '@opentelemetry/sdk-node';
const sdk = new NodeSDK({ /* config */ });
sdk.start();
```

### Environment Config

Use environment variables for config:
```python
port = int(os.environ.get("PORT", 5050))
```

Never hardcode credentials or URLs.

## Integration

These services are checked by `scripts\smoke.ps1`:

```powershell
.\scripts\smoke.ps1
```

Add your own services to the smoke test for automated health checks.

## Related

- [Templates](../templates/) - Starter templates for new services
- [Docs](../docs/) - Documentation and ADRs
- [Scripts](../scripts/) - Automation scripts
