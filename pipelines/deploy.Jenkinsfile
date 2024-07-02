pipeline {
    agent any
    
    parameters { 
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: '', description: 'Docker image to deploy')
    }

    stages {
        stage('Update Deployment') {
            steps {
                script {
                    // Update Kubernetes deployment YAML to use the new Docker image
                    sh """
                    # Assuming you have a local copy of the deployment YAML
                    sed -i 's|image: .*|image: ${params.IMAGE_FULL_NAME_PARAM}|g' k8s/deployment.yaml

                    # Commit the updated YAML file
                    git config user.name "jenkins"
                    git config user.email "jenkins@example.com"
                    git add k8s/deployment.yaml
                    git commit -m "Update deployment to use ${params.IMAGE_FULL_NAME_PARAM}"
                    git push origin main
                    """
                }
            }
        }
    }
}

