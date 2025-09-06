# Dockerized Flask AWS App

This project demonstrates how to containerize a Python-based Flask application that interacts with AWS services using environment variables for credentials. The app runs in a Docker container and listens on port **5001**.

## 📦 Features

- Dockerized Python Flask application
- Environment-based AWS credentials
- Hosted on **EC2** using SSH and Docker
- Error display for missing credentials

---

## 🐳 Docker Setup

### Dockerfile

This is the Dockerfile used to build the image:

```dockerfile
FROM python:3.10-slim

RUN apt-get update && \
    apt-get install -y python3 python3-pip

WORKDIR /app

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 5001

CMD ["python", "main.py"]
```

---

## 📁 Project Structure

```
.
├── Dockerfile
├── main.py
├── requirements.txt
└── README.md
```

---

## 🚀 Deployment Steps

1. **Push to GitHub**

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

2. **SSH into EC2 Builder Instance**

   ```bash
   ssh -i your-key.pem ec2-user@your-ec2-ip
   ```

3. **Clone and Build Docker Image**

   ```bash
   git clone <your-repo-url>
   cd <your-project-directory>
   docker build -t flask-aws-app .
   ```

4. **Run Docker Container**

   ```bash
   docker run -d -p 5001:5001 \
     -e AWS_ACCESS_KEY_ID=your_key \
     -e AWS_SECRET_ACCESS_KEY=your_secret \
     flask-aws-app
   ```

---

## 🌐 Access the App

Visit [http://localhost:5001](http://localhost:5001) or `http://<your-ec2-ip>:5001`.

---

## 🐞 Expected Error Output

If AWS credentials are not set, the app will fail to connect to AWS and return the following error:

![alt text](<error messege.png>)