# 🚀 Kubernetes Canary Rollouts with Argo Rollouts & FastAPI

This project demonstrates a production-grade **canary deployment strategy** using **Argo Rollouts** with a simple **FastAPI** application. It includes:
- Manual promotion at each stage
- Prometheus-based auto-rollback
- Emergency deployment bypass
- Audit and observability support

---

## 📦 Tech Stack
- Kubernetes (YAML based manifests)
- Argo Rollouts
- FastAPI
- Prometheus
- NGINX Ingress Controller
- Docker

---

## 🏗️ Project Structure
```
.
├── app/                  # FastAPI source code
├── argo-rollouts/        # Rollout + AnalysisTemplate YAMLs
├── manifests/            # Namespace, service, ingress, hotfix
├── prometheus/           # Prometheus config & pod
├── scripts/              # Rollout and emergency automation scripts
└── README.md
```

---

## ⚙️ Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/vedant-kakde/argo-rollouts-canary-demo.git
cd argo-rollouts-canary-demo
```

### 2. Build and Push Docker Images
```bash
cd app/
# v1
docker build -t vedantkakde/fastapi-app:v1 .
docker push vedantkakde/fastapi-app:v1

# v2 (modify response in main.py)
docker build -t vedantkakde/fastapi-app:v2 .
docker push vedantkakde/fastapi-app:v2

# hotfix
docker build -t vedantkakde/fastapi-app:hotfix .
docker push vedantkakde/fastapi-app:hotfix
```

### 3. Start Kubernetes Cluster (example: minikube)
```bash
minikube start --addons=ingress
```

### 4. Install Argo Rollouts & NGINX Ingress
```bash
kubectl apply -n canary-demo -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml
```

### 5. Deploy Resources
```bash
kubectl apply -f manifests/
kubectl apply -f argo-rollouts/
kubectl apply -f prometheus/
```

---

## 🚦 Canary Rollout Lifecycle

### Watch Rollout:
```bash
kubectl argo rollouts get rollout fastapi-rollout -n canary-demo --watch
```

### Promote Rollout Step-by-Step:
```bash
kubectl argo rollouts promote fastapi-rollout -n canary-demo
```

### Abort and Rollback:
```bash
kubectl argo rollouts abort fastapi-rollout -n canary-demo
```

### Automated Demo:
```bash
./scripts/rollout-demo.sh
```

---

## 📉 Prometheus-based Auto-Rollback

### Access Prometheus:
```bash
kubectl port-forward prometheus -n canary-demo 9090:9090
```
Browse: [http://localhost:9090](http://localhost:9090)

Prometheus will auto-trigger rollback if >10% 5xx errors are detected during rollout.

---

## 🆘 Emergency Hotfix Deployment (Bypass Rollouts)

If a critical issue arises:
```bash
./scripts/emergency-hotfix.sh
```
This deploys `fastapi-app:hotfix` directly using a regular Deployment.

---

## 📊 Observability & Health Checks
- `/health` → readiness probe
- `/metrics` (on port 8001) → Prometheus metrics
- `http_requests_total{version=...}` → visible traffic by version

---

## 🧪 Test the App
```bash
curl -s http://<INGRESS-IP>/
```
You’ll see: `"Hello from v1"` or `"Hello from v2"`

Use `watch -n1 curl http://<INGRESS-IP>/` to observe traffic split.

---

## 📸 Demo Screenshots / Video

> 📷 Add your screenshots or a Loom/Youtube link showing:
> - Initial rollout
> - Promotion steps
> - Failure + rollback
> - Emergency deployment

---

## 👤 Audit and Logging

All rollout actions are traceable via:
```bash
kubectl argo rollouts get rollout fastapi-rollout -n canary-demo
```
You can also use Argo Rollouts UI (`kubectl argo rollouts dashboard`) if enabled.

---

## 📌 Notes

- Namespace used: `canary-demo`
- Update `APP_VERSION` env var in rollout YAML when changing versions
- Use `kubectl describe` or `kubectl logs` to debug health checks

