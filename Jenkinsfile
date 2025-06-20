pipeline {
  agent {
    docker {
      image 'maven:3.8.6-openjdk-11'
      args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
    IMAGE_NAME = "your-dockerhub-username/java-hello-app:${BUILD_NUMBER}"
    DOCKERHUB_CREDENTIALS = "dockerhub"
    SCANNER_HOME = tool 'sonar-scanner'
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/yourusername/java-hello-app.git'
      }
    }

    stage('SonarQube Scan') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh '$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=java-hello-app -Dsonar.sources=./src'
        }
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
          sh '''
            echo "$PASS" | docker login -u "$USER" --password-stdin
            docker push $IMAGE_NAME
          '''
        }
      }
    }
  }
}
