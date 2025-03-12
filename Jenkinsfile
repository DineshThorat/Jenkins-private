pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = credentials('azure-service-principal-json')
        RESOURCE_GROUP = 'Dinesh-Demo-RG'  
        ACR_NAME = 'dineshacr001'    
        IMAGE_NAME = 'python-app'
        IMAGE_TAG = 'latest'
        AKS_CLUSTER = 'dinesh-cluster-01'
        NAMESPACE = 'default'
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
        
        stage('AKS Deployment') {
            steps {
                script {
                    sh """
                    echo "Fetching AKS credentials..."
                    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --overwrite-existing
                    
                    echo "Deploying application to AKS..."
                    kubectl apply -f manifest.yml
                    
                    echo "Verifying deployment..."
                    kubectl get pods -n $NAMESPACE
                    """
                }
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
