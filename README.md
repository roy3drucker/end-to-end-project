# 🚀 End-to-End Flask AWS App (CI/CD with Docker, Jenkins, Helm & Kubernetes)

![Docker](https://img.shields.io/badge/docker-ready-blue)
![Python](https://img.shields.io/badge/python-3.10-blue.svg)
![Flask](https://img.shields.io/badge/flask-web--app-red)
![Jenkins](https://img.shields.io/badge/CI--CD-jenkins-yellow)
![Helm](https://img.shields.io/badge/kubernetes-helm-blue)

This project demonstrates an end-to-end CI/CD pipeline for a Flask-based application that integrates:

- Docker containerization  
- Deployment to Kubernetes via **Helm**  
- Continuous integration using **Jenkins**
- Secure image builds using **Kaniko**
- Application runtime inside **Minikube**
- AWS resource data display using **Boto3**

---

## 📚 Table of Contents

- [Features](#-features)
- [Architecture Overview](#-architecture-overview)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [CI/CD Pipeline with Jenkins](#-cicd-pipeline-with-jenkins)
- [Kubernetes Deployment with Helm](#-kubernetes-deployment-with-helm)
- [Project Structure](#-project-structure)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)

---

## ✨ Features

- Python Flask app that queries AWS (EC2, VPC, AMIs, ELB)
- Dockerized and published to DockerHub
- CI/CD pipeline with Jenkins using **Kaniko** to build and push images securely
- Helm charts for Kubernetes deployment
- Running locally on **Minikube**
- Auto-tagging of builds using timestamps

---

## 🧱 Architecture Overview

```text
        +------------+         +--------------+
        |  Developer |  ---->  |  GitHub Repo |
        +------------+         +--------------+
                                    |
                                    v
                             +------------+
                             |  Jenkins   |   <-- Triggers build on push
                             +------------+
                                  |
                +----------------+----------------+
                |                                 |
        +---------------+                +----------------+
        |  Kaniko Build |                |  Lint / Scan   |
        +---------------+                +----------------+
                |
                v
         DockerHub (Image Registry)
                |
                v
      +---------------------+
      | Kubernetes (Helm)   |
      |   via Minikube      |
      +---------------------+
                |
                v
        http://localhost:5001
