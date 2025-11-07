pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["cat"]
    tty: true
  - name: helm
    image: alpine/helm:3.13.0
    command: ["cat"]
    tty: true
  - name: python
    image: python:3.10
    command: ["cat"]
    tty: true
  - name: git
    image: alpine/git:2.45.2
    command: ["cat"]
    tty: true
"""
      defaultContainer 'kaniko'
    }
  }

  environment {
    IMAGE_REPO      = 'dockerdrucker/flask-aws-app'
    DOCKERFILE_PATH = 'Dockerfile'
    BUILD_CONTEXT   = 'section-3-dockerizing-app'
    HELM_CHART_PATH = 'Helm/flask-aws-monitor'
    HELM_RELEASE_NAME = 'flask-aws-monitor'
    HELM_NAMESPACE  = 'flask-app'
    HELM_TIMEOUT    = '5m'
    APP_PORT        = '5001'
    SERVICE_TYPE    = 'LoadBalancer'
    DOCKERHUB_USERNAME_CREDENTIAL_ID = 'dockerdrucker-username'
    DOCKERHUB_PASSWORD_CREDENTIAL_ID = 'dockerdrucker-password'
    GIT_CREDENTIALS_ID = 'github-credentials'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git branch: 'main', url: 'https://github.com/roy3drucker/end-to-end-project'
      }
    }

    stage('Compute Tag') {
      steps {
        script {
          def ts = sh(returnStdout: true, script: "date +%Y%m%d-%H%M%S").trim()
          env.IMAGE_TAG = "${ts}"
          echo "IMAGE_TAG=${env.IMAGE_TAG}"
        }
      }
    }

    stage('Linting') {
      steps {
        container('python') {
          sh '''
            pip install flake8
            flake8 section-3-dockerizing-app/
            curl -L https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint
            chmod +x /usr/local/bin/hadolint
            hadolint section-3-dockerizing-app/Dockerfile
          '''
        }
      }
    }

    stage('Build & Push (Kaniko)') {
      steps {
        withCredentials([
          string(credentialsId: env.DOCKERHUB_USERNAME_CREDENTIAL_ID, variable: 'DOCKERHUB_USERNAME'),
          string(credentialsId: env.DOCKERHUB_PASSWORD_CREDENTIAL_ID, variable: 'DOCKERHUB_PASSWORD')
        ]) {
          sh '''
            echo "==> Docker auth"
            mkdir -p /kaniko/.docker
            AUTH=$(printf "%s" "${DOCKERHUB_USERNAME}:${DOCKERHUB_PASSWORD}" | base64 | tr -d '\\n')
            printf '{"auths":{"https://index.docker.io/v1/":{"auth":"%s"}}}\n' "$AUTH" > /kaniko/.docker/config.json

            echo "==> Kaniko build & push"
            /kaniko/executor \
              --verbosity=debug \
              --context="${BUILD_CONTEXT}" \
              --dockerfile="${DOCKERFILE_PATH}" \
              --destination="${IMAGE_REPO}:${IMAGE_TAG}" \
              --destination="${IMAGE_REPO}:latest"
          '''
        }
      }
    }

    stage('Update values.yaml & Push to GitHub') {
      steps {
        container('git') {
          withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
            sh '''
              sed -i "s|^image:.*|image: ${IMAGE_REPO}:${IMAGE_TAG}|" ${HELM_CHART_PATH}/values.yaml

              git config --global user.email "jenkins@example.com"
              git config --global user.name "Jenkins CI"
              git config --global --add safe.directory "$(pwd)"
              git config --global --add safe.directory /home/jenkins/agent/workspace/my-pipeline
              git config --global user.email "jenkins@example.com"
              git config --global user.name "Jenkins CI"
              git add ${HELM_CHART_PATH}/values.yaml
              git commit -m "Update image tag to ${IMAGE_TAG}" || echo "No changes to commit"
              git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/roy3drucker/end-to-end-project.git
              git push origin main
            '''
          }
        }
      }
    }

      stage('Post Actions') {
        steps {
          echo "Pipeline completed successfully"
        }
      }
  }

  post {
    failure {
      echo 'Pipeline failed! Check logs for details.'
    }
  }
}
