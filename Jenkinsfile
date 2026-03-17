pipeline {
  agent any

  environment {
    APP_IMAGE = "helloworld:${env.BUILD_NUMBER}"
    GITHUB_REPO = "https://github.com/zhiwenwang30-boop/helloworld.git"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Static Code Scan') {
      steps {
        sh '''
          docker run --rm \
            -v "$PWD":/workspace \
            -w /workspace \
            python:3.12-slim \
            sh -c "pip install --no-cache-dir ruff bandit && ruff check main.py && bandit -q -r main.py"
        '''
      }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t ${APP_IMAGE} .'
      }
    }

    stage('Run HelloWorld') {
      steps {
        sh 'docker run --rm ${APP_IMAGE}'
      }
    }

    stage('Push To GitHub') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'github-push-cred',
            usernameVariable: 'GIT_USERNAME',
            passwordVariable: 'GIT_TOKEN'
          )
        ]) {
          sh '''
            git config user.name "jenkins-bot"
            git config user.email "jenkins@example.local"
            AUTH_REPO_URL=$(echo "${GITHUB_REPO}" | sed "s#https://#https://${GIT_USERNAME}:${GIT_TOKEN}@#")
            git remote set-url origin "${AUTH_REPO_URL}"
            git push origin HEAD:main
            git remote set-url origin "${GITHUB_REPO}"
          '''
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline success: static scan/build/run/push all passed.'
    }
    failure {
      echo 'Pipeline failed. Please inspect the failed stage logs.'
    }
  }
}


