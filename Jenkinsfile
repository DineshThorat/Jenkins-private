pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = credentials('azure-service-principal-json')
        RESOURCE_GROUP = 'Dinesh-Demo-RG'  
        ACR_NAME = 'dineshacr001'    
        IMAGE_NAME = 'python-app'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Azure Login') {
            steps {
                script {
                    def creds = readJSON text: AZURE_CREDENTIALS
                    sh """
                    echo "Logging into Azure..."
                    az login --service-principal -u ${creds.client_id} -p ${creds.client_secret} --tenant ${creds.tenant_id}
                    az account set --subscription ${creds.subscription_id}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo "Building Docker Image..."
                docker build -t $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Login to ACR') {
            steps {
                script {
                    sh "az acr login --name $ACR_NAME"
                }
            }
        }

        stage('Push Image to ACR') {
            steps {
                sh '''
                echo "Pushing Docker Image to ACR..."
                docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build & Push Successful!"
        }
        failure {
            echo "❌ Pipeline Failed!"
        }
    }
}
