pipeline {
    agent any
    environment {
        PATH_TF = 'NodejsApp_GCP'
        TFACTION = "apply"
        GCP_PROJECT_ID = 'gcp-cloudrun-nodejs-mysql-app'      
        GCP_CREDENTIALS = credentials('gcp-service-account-key') 
        GIT_CREDENTIALS_ID = 'git-credentials-id'
        GIT_REPO_URL = 'https://github.com/anitamaharana55/NodejsApp_GCP.git'
        CLIENT_EMAIL='nodejsdemo@gcp-cloudrun-nodejs-mysql-app.iam.gserviceaccount.com'
    }
    stages {
        stage('Authenticate to GCP') {
            steps {
                // Using the GCP service account key as a secret file
                withCredentials([file(credentialsId: 'gcp-service-account-key', variable: 'GCP_KEY_FILE')]) {
                    script {

                        // Authenticate using the secret file path
                        sh 'gcloud auth activate-service-account --key-file=$GCP_KEY_FILE'
                        sh 'gcloud config set project ${GCP_PROJECT_ID}'
                        sh 'gcloud auth list'
                        sh 'gcloud config list'
                        
                    }
                }
            }
        }
        stage('Checkout Code') {
            steps {
                // Cloning the repository
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']],          
                    userRemoteConfigs: [[url: "${GIT_REPO_URL}", credentialsId: "${GIT_CREDENTIALS_ID}"]]
                ])
            }
        }
        stage('Install dependencies') {
            steps {
                script {
                    sh 'python3 -m venv venv'  
                    sh './venv/bin/pip install --upgrade pip'  
                    sh './venv/bin/pip install checkov'
                }
            }
        }
        stage('Checkov Scan') {
            steps {
                sh './venv/bin/checkov --version'
                sh './venv/bin/checkov -d . --output json --output-file checkov_report.json --quiet || (echo "Checkov scan failed!" && exit 1)'
            }
        }
        stage('Terraform Init') {
            steps {
                sh '''
                    terraform init -reconfigure
                '''
        }
            }
        
        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform refresh
                    terraform plan
                '''
            }
        }
        stage('Terraform Apply or Destroy') {
            steps {
                sh '''
                    terraform apply -auto-approve
                '''
            }
        }
    }
}
    