# End-to-End DevOps Project: Flask AWS Monitor with Kubernetes & Helm

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://hub.docker.com/r/dockerdrucker/flask-aws-app)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat&logo=helm&logoColor=white)](https://helm.sh/)

## 📋 Project Overview

This is a complete **end-to-end DevOps project** that demonstrates:

1. **Dockerization** of a Flask application for AWS resource monitoring
2. **Kubernetes deployment** using Helm charts for scalability and management
3. **Infrastructure as Code** approach with templated configurations
4. **Production-ready** deployment patterns with service discovery and ingress

### 🎯 Learning Objectives
- Container orchestration with Kubernetes
- Package management with Helm
- Template-based deployments
- Service mesh and ingress configuration
- DevOps best practices

## 🏗️ Project Architecture

```
end-to-end-project/
├── Helm/
│   └── flask-aws-monitor/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deploy.yaml
│           ├── service.yaml
│           └── ingress.yaml
└── README.md
```

## 🔧 Prerequisites

Before deploying this application, ensure you have:

| Tool | Version | Purpose |
|------|---------|----------|
| **Kubernetes** | 1.20+ | Container orchestration platform |
| **Helm** | 3.x | Kubernetes package manager |
| **kubectl** | Latest | Kubernetes CLI tool |
| **Docker** | 20.x+ | Container runtime (for local testing) |

### 🐳 Docker Image
- **Registry**: Docker Hub
- **Image**: `dockerdrucker/flask-aws-app:latest`
- **Base**: Python Flask application
- **Port**: 5001
- **Purpose**: AWS resource monitoring dashboard

## 🚀 Quick Start Guide

### Step 1: Environment Verification
```bash
# Verify Kubernetes cluster is running
kubectl cluster-info
kubectl get nodes

# Check Helm installation
helm version --short

# Confirm kubectl context
kubectl config current-context
```

### Step 2: Deploy the Application
```bash
# Clone the repository (if not already done)
git clone <your-repo-url>
cd end-to-end-project/Helm/flask-aws-monitor

# Deploy with default configuration
helm install flask-monitor . --create-namespace --namespace flask-app

# Or deploy with custom values
helm install flask-monitor . -f custom-values.yaml
```

### Step 3: Verify Deployment Status
```bash
# Check deployment status
helm status flask-monitor -n flask-app

# Verify all resources are running
kubectl get all -n flask-app -l app=flask-monitor

# Check pod logs
kubectl logs -n flask-app -l app=flask-monitor --tail=50
```

## ⚙️ Configuration

### Default Configuration (values.yaml)

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `port` | `5001` | Application port |
| `image` | `dockerdrucker/flask-aws-app:latest` | Docker image |
| `servicetype` | `ClusterIP` | Kubernetes service type |

### 📝 Current Configuration
```yaml
port: 5001
image: dockerdrucker/flask-aws-app:latest
servicetype: ClusterIP
```

### Customizing Deployment
You can override default values during installation:

```bash
# Change service type to LoadBalancer
helm install flask-monitor . --set servicetype=LoadBalancer

# Use different image tag
helm install flask-monitor . --set image=dockerdrucker/flask-aws-app:v2.0

# Change port
helm install flask-monitor . --set port=8080
```

Or create a custom values file:
```yaml
# custom-values.yaml
port: 8080
image: dockerdrucker/flask-aws-app:v2.0
servicetype: LoadBalancer
```

```bash
helm install flask-monitor . -f custom-values.yaml
```

## 🌐 Accessing the Application

### Method 1: Port Forwarding (Development)
```bash
# Forward local port to service
kubectl port-forward -n flask-app svc/flask-monitor 5001:5001

# Open browser to: http://localhost:5001
```

### Method 2: LoadBalancer Service (Production)
```bash
# Update service type
helm upgrade flask-monitor . --set servicetype=LoadBalancer -n flask-app

# Get external IP (may take a few minutes)
kubectl get svc flask-monitor -n flask-app -w

# Access via: http://<EXTERNAL-IP>:5001
```

### Method 3: Ingress Controller (Recommended)
```bash
# Ensure Nginx Ingress Controller is installed
kubectl get pods -n ingress-nginx

# Get ingress IP
kubectl get ingress -n flask-app

# Access via: http://<INGRESS-IP>/
```

## 🔄 Helm Management Commands

### Upgrade Deployment
```bash
# Upgrade with new values
helm upgrade flask-monitor . --set servicetype=LoadBalancer

# Upgrade with values file
helm upgrade flask-monitor . -f custom-values.yaml
```

### Check Release Status
```bash
# List all releases
helm list

# Get release status
helm status flask-monitor

# Get release history
helm history flask-monitor
```

### Rollback
```bash
# Rollback to previous version
helm rollback flask-monitor

# Rollback to specific revision
helm rollback flask-monitor 1
```

### Uninstall
```bash
# Remove the application
helm uninstall flask-monitor
```

## 🔍 Troubleshooting Guide

### Common Issues & Solutions

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Pods not starting** | `Pending` or `CrashLoopBackOff` | Check logs and resource limits |
| **Service unreachable** | Connection refused | Verify service endpoints |
| **Image pull errors** | `ImagePullBackOff` | Confirm image exists and is accessible |
| **Ingress not working** | 404 errors | Check ingress controller and rules |

### 🛠️ Debug Commands
```bash
# Comprehensive status check
kubectl get all -n flask-app

# Pod diagnostics
kubectl describe pod -n flask-app -l app=flask-monitor
kubectl logs -n flask-app -l app=flask-monitor --previous

# Service connectivity
kubectl get endpoints -n flask-app
kubectl describe svc flask-monitor -n flask-app

# Recent events
kubectl get events -n flask-app --sort-by=.metadata.creationTimestamp

# Helm release information
helm get values flask-monitor -n flask-app
helm get manifest flask-monitor -n flask-app
```

## Development

### Local Testing
```bash
# Dry run to validate templates
helm install flask-monitor . --dry-run --debug

# Template rendering
helm template flask-monitor .
```

### Linting
```bash
# Lint the chart
helm lint .
```

## Docker Image Details
- **Base Image**: Python Flask application
- **Port**: 5001
- **Purpose**: AWS resource monitoring
- **Registry**: Docker Hub (`dockerdrucker/flask-aws-app`)

## 🛠️ Technology Stack

| Layer | Technology | Purpose |
|-------|------------|----------|
| **Application** | Flask (Python) | Web framework for AWS monitoring |
| **Containerization** | Docker | Application packaging |
| **Orchestration** | Kubernetes | Container management |
| **Package Management** | Helm | Deployment automation |
| **Service Mesh** | Nginx Ingress | Traffic routing |
| **Cloud Platform** | AWS | Resource monitoring target |

## 📊 Project Metrics

- **Deployment Time**: ~2-3 minutes
- **Resource Usage**: Minimal (suitable for development)
- **Scalability**: Horizontal pod autoscaling ready
- **High Availability**: Multi-replica support

## 🎓 Learning Outcomes

After completing this project, you will understand:

- ✅ Kubernetes deployment patterns
- ✅ Helm chart structure and templating
- ✅ Service discovery and networking
- ✅ Ingress configuration and routing
- ✅ Container orchestration best practices
- ✅ Infrastructure as Code principles

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

## 📄 License

This project is part of an **end-to-end DevOps learning demonstration**.

---

**Built with ❤️ for DevOps learning and best practices**
