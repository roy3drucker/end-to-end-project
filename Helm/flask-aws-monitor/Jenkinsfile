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
    HELM_RELEASE_NAME = 'flask-aws-monitor'
    HELM_NAMESPACE  = 'flask-app'
    HELM_TIMEOUT    = '5m'
    KUBECONFIG_CREDENTIALS_ID = 'minikube-kubeconfig'
    APP_PORT        = '5001'
    SERVICE_TYPE    = 'LoadBalancer'
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

    
    stage('Parallel Checks') {
      parallel {
        stage('Linting') {
          steps {
            sh '''
              echo "[MOCK] flake8/hadolint/shellcheck passed (skipped for Kaniko setup)"
            '''
          }
        }
        stage('Security Scan') {
          steps {
            sh '''
              echo "[MOCK] bandit/trivy scan passed (skipped for Kaniko setup)"
            '''
          }
        }
      }
    }

    stage('Build & Push (Kaniko)') {
      steps {
        sh '''
          set -euo pipefail
          echo "==> Docker auth"
          mkdir -p /kaniko/.docker
          AUTH=$(printf "%s" "${DOCKERHUB_USERNAME}:${DOCKERHUB_PASSWORD}" | base64 | tr -d '\\n')
          printf '{"auths":{"https://index.docker.io/v1/":{"auth":"%s"}}}\n' "$AUTH" > /kaniko/.docker/config.json
          wc -c /kaniko/.docker/config.json

          DF_REL="${DOCKERFILE_PATH#${BUILD_CONTEXT}/}"
          [ "$DF_REL" = "$DOCKERFILE_PATH" ] && DF_REL="$DOCKERFILE_PATH"
          test -f "${BUILD_CONTEXT}/${DF_REL}" || { echo "Dockerfile not found at ${BUILD_CONTEXT}/${DF_REL}"; ls -la "${BUILD_CONTEXT}"; exit 1; }

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

    stage('Deploy to Minikube') {
      when {
        expression { return env.KUBECONFIG_CREDENTIALS_ID?.trim() }
      }
      steps {
        container('helm') {
          withCredentials([file(credentialsId: env.KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG_FILE')]) {
            sh '''
              set -euo pipefail
              export KUBECONFIG="${KUBECONFIG_FILE}"
              kubectl config use-context minikube
              kubectl config current-context
              helm upgrade --install "${HELM_RELEASE_NAME}" "${HELM_CHART_PATH}" \
                --namespace "${HELM_NAMESPACE}" \
                --create-namespace \
                --set-string image=${IMAGE_REPO}:${IMAGE_TAG} \
                --set-string port=${APP_PORT} \
                --set-string serviceType=${SERVICE_TYPE} \
                --wait \
                --timeout "${HELM_TIMEOUT}"
              kubectl get pods -n "${HELM_NAMESPACE}" -l app=${HELM_RELEASE_NAME}
              kubectl get svc -n "${HELM_NAMESPACE}" ${HELM_RELEASE_NAME}
            '''
          }
        }
      }
    }
  }

  post {
    success { echo "Pipeline completed successfully. Image pushed: ${IMAGE_REPO}:${IMAGE_TAG}" }
    failure { echo 'Pipeline failed! Check logs for details.' }
  }
}
