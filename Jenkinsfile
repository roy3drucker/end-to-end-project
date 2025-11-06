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
"""
      defaultContainer 'kaniko'
    }
  }

  environment {
    DOCKERHUB_USERNAME = credentials('dockerdrucker-username')
    DOCKERHUB_PASSWORD = credentials('dockerdrucker-password')
    IMAGE_REPO      = 'dockerdrucker/flask-aws-app'
    DOCKERFILE_PATH = 'Dockerfile'
    BUILD_CONTEXT   = 'section-3-dockerizing-app'
    HELM_CHART_PATH = 'Helm/flask-aws-monitor'
    APP_PORT        = '5001'
    SERVICE_TYPE    = 'LoadBalancer'
    GIT_CREDENTIALS_ID = 'github-push-token'
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
      agent {
        docker {
          image 'python:3.10'
        }
      }
      steps {
        sh '''
          apt-get update
          apt-get install -y python3-pip curl
          
          pip install flake8
          flake8 section-3-dockerizing-app/
          
          curl -L https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint
          chmod +x /usr/local/bin/hadolint
          hadolint section-3-dockerizing-app/Dockerfile
        '''
      }
    }

    stage('Build & Push (Kaniko)') {
      steps {
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

    stage('Update values.yaml & Push to GitHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.GIT_CREDENTIALS_ID, usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
          sh '''
            echo "==> Update image tag in values.yaml"
            sed -i "s|image: .*|image: ${IMAGE_REPO}:${IMAGE_TAG}|" ${HELM_CHART_PATH}/values.yaml

            echo "==> Git config and push"
            git config user.email "ci@jenkins.com"
            git config user.name "Jenkins CI"
            git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/roy3drucker/end-to-end-project.git
            git add ${HELM_CHART_PATH}/values.yaml
            git commit -m "CI: Update image tag to ${IMAGE_TAG}"
            git push origin main
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ CI pipeline succeeded, Git updated – ArgoCD will deploy."
    }
    failure {
      echo "❌ Pipeline failed. Check logs for errors."
    }
  }
}
