pipeline {
    agent any
    environment {
        TFACTION = "apply"
        GCP_PROJECT_ID = 'gcp-cloudrun-nodejs-mysql-app'      
        GCP_CREDENTIALS = credentials('gcp-service-account-key') 
        GIT_CREDENTIALS_ID = 'git-credentials-id'
        // GIT_REPO_URL = 'https://github.com/anitamaharana55/NodejsApp_GCP.git'
        GIT_REPO_URL = 'https://github.com/UmeshBuraWissen/gcp-cloudrun-nodejs-mysql-infra.git'
        CLIENT_EMAIL='nodejsdemo@gcp-cloudrun-nodejs-mysql-app.iam.gserviceaccount.com'
    }
    stages {
        stage('Authenticate to GCP') {
            steps {
                withCredentials([file(credentialsId: 'gcp-service-account-key', variable: 'GCP_KEY_FILE')]) {
                    script {
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
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']],          
                    userRemoteConfigs: [[url: "${GIT_REPO_URL}", credentialsId: "${GIT_CREDENTIALS_ID}"]]
                ])
            }
        }
        stage('Checkov Scan') {
            steps {
                script {
                    echo "Setting up Python virtual environment and installing Checkov..."
                    sh 'python3 -m venv venv'
                    sh '''
                        . venv/bin/activate  
                        pip install --upgrade pip    
                        pip install checkov
                    '''
                    sh '''
                        . venv/bin/activate  
                        checkov --version            
                    '''
                    sh '''
                        . venv/bin/activate  
                        echo "Current PATH: $PATH"  
                        which checkov  
                        cd GCP-CloudRun-Nodejs-Mysql-infra
                        checkov -d . --skip-check CKV_GCP_113,CKV_GCP_60 --output json --output-file checkov_report.json --quiet || (echo "Checkov scan failed!" && exit 1)
                    '''
                }
            }
        }
        stage('Terraform Init') {
            steps {
                sh '''
                cd GCP-CloudRun-Nodejs-Mysql-infra
                    terraform init -reconfigure
                '''
            }
        }
        stage('Terraform Plan') {
            steps {
                sh '''
                cd GCP-CloudRun-Nodejs-Mysql-infra
                    terraform refresh
                    terraform plan
                '''
            }
        }
        stage('Terraform Apply or Destroy') {
            steps {
                sh '''
                cd GCP-CloudRun-Nodejs-Mysql-infra
                    terraform apply -auto-approve
                '''
            }
        }
    }
}
    