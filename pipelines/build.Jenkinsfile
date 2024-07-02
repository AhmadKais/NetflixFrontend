pipeline {
    agent any
    
    triggers {
        githubPush()   // Trigger the pipeline upon push event in GitHub
    }
    
    options { 
        timeout(time: 10, unit: 'MINUTES')  // Discard the build after 10 minutes
        timestamps()  // Display timestamps in console output
    }
    
    environment { 
        // Define environment variables
        IMAGE_TAG = "v1.0.$BUILD_NUMBER"
        IMAGE_BASE_NAME = 'netflix-app'
        
        DOCKER_USERNAME = credentials('dockerhub').username
        DOCKER_PASS = credentials('dockerhub').password
    } 

    stages {
        stage('Docker setup') {
            steps {             
                sh '''
                  docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                '''
            }
        }
        
        stage('Build & Push') {
            steps {             
                sh '''
                  IMAGE_FULL_NAME=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG
                
                  docker build -t $IMAGE_FULL_NAME .
                  docker push $IMAGE_FULL_NAME
                '''
            }
        }
        
        stage('Trigger Deploy') {
            steps {
                build job: 'NetflixFrontendDeploy', wait: false, parameters: [
                    string(name: 'IMAGE_FULL_NAME_PARAM', value: "${DOCKER_USERNAME}/${IMAGE_BASE_NAME}:${IMAGE_TAG}")
                ]
            }
        }
    }
}
