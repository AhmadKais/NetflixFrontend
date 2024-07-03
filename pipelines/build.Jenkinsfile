pipeline {
    agent any
    
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
                          # Add Docker's official GPG key:
                          sudo apt-get update
                          sudo apt-get install ca-certificates curl
                          sudo install -m 0755 -d /etc/apt/keyrings
                          sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                          sudo chmod a+r /etc/apt/keyrings/docker.asc

                          # Add the repository to Apt sources:
                          echo \
                          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                          sudo apt-get update
                          sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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
