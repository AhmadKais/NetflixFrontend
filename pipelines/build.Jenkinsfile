pipeline {
    agent {
        docker {
            image 'docker:latest'  // Use a Docker image with Docker installed
            args '-v /var/run/docker.sock:/var/run/docker.sock'  // Mount Docker socket
        }
    }

    triggers {
        githubPush()   // Trigger the pipeline upon push event in GitHub
    }

    options {
        timeout(time: 10, unit: 'MINUTES')  // Discard the build after 10 minutes of running
        timestamps()  // Display timestamp in console output
    }

    environment {
        IMAGE_TAG = "v1.0.$BUILD_NUMBER"
        IMAGE_BASE_NAME = 'netflix-app'
    }

    stages {
        stage('Docker setup') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                          docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                        '''
                    }
                }
            }
        }
        
        stage('Build & Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                          IMAGE_FULL_NAME=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG
                          docker build -t $IMAGE_FULL_NAME .
                          docker push $IMAGE_FULL_NAME
                        '''
                    }
                }
            }
        }
    }
}
