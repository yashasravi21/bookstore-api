pipeline {
    agent any

    environment {
        IMAGE_NAME     = "bookstore-api"
        CONTAINER_NAME = "bookstore-api"
        HOST_PORT      = "8081"
        APP_PORT       = "8080"
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                // "verify" compiles the code AND runs the unit tests.
                sh 'mvn -B clean verify'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true, allowEmptyArchive: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                  docker stop ${CONTAINER_NAME} || true
                  docker rm ${CONTAINER_NAME} || true

                  docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${HOST_PORT}:${APP_PORT} \
                    --restart unless-stopped \
                    ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                  echo "Waiting for the application to start..."
                  for i in $(seq 1 30); do
                    if curl -fs http://localhost:${HOST_PORT}/actuator/health > /dev/null; then
                      echo "Health check passed."
                      curl -s http://localhost:${HOST_PORT}/books
                      exit 0
                    fi
                    sleep 3
                  done
                  echo "Application did not become healthy in time."
                  docker logs ${CONTAINER_NAME}
                  exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "Build ${IMAGE_TAG} deployed successfully on port ${HOST_PORT}."
        }
        failure {
            echo "Build ${IMAGE_TAG} failed. Check the stage log above."
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}
