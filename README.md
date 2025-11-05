# 🚀 End-to-End Flask AWS App (CI/CD with Docker, Jenkins, Helm & Kubernetes)

![Docker](https://img.shields.io/badge/docker-ready-blue)
![Python](https://img.shields.io/badge/python-3.10-blue.svg)
![Flask](https://img.shields.io/badge/flask-web--app-red)
![Jenkins](https://img.shields.io/badge/CI--CD-jenkins-yellow)
![Helm](https://img.shields.io/badge/kubernetes-helm-blue)

This is a full end-to-end DevOps pipeline project that:

- Builds a **Flask** app that queries AWS services (EC2, VPC, ELB, AMIs)
- Uses **Docker** to containerize the app
- Runs a full **CI/CD pipeline** using **Jenkins + Kaniko**
- Pushes to **DockerHub**
- Deploys to **Kubernetes (Minikube)** using **Helm**

---

## 📚 Table of Contents

- [Features](#-features)
- [CI/CD Pipeline Diagram](#cicd-pipeline-diagram)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [CI/CD Pipeline with Jenkins](#-cicd-pipeline-with-jenkins)
- [Kubernetes Deployment with Helm](#-kubernetes-deployment-with-helm)
- [Project Structure](#-project-structure)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)
- [Contributors](#-contributors)

---

## ✨ Features

- Flask web application with Python 3.10
- Containerized with Docker
- Secure build via Kaniko (inside Jenkins pod)
- Push to DockerHub (`dockerdrucker/flask-aws-app`)
- Kubernetes deployment using Helm
- Access AWS via Boto3

---

## 🖼️ CI/CD Pipeline Diagram

![CI/CD Pipeline](cicd-pipeline.png)

> 📝 Make sure this image is placed in the **root folder** next to this README file.

---

## 🔧 Prerequisites

Before you begin, make sure you have the following:

- ✅ Docker
- ✅ Python 3.10+
- ✅ Helm (v3+)
- ✅ Minikube (Kubernetes local cluster)
- ✅ Jenkins running with Kubernetes plugin
- ✅ DockerHub account & credentials saved in Jenkins
- ✅ AWS credentials exported to environment variables:
  ```bash
  export AWS_ACCESS_KEY_ID=xxx
  export AWS_SECRET_ACCESS_KEY=yyy



