pipeline {
    agent any

    environment {
        S3_BUCKET   = 'jenkins-s3-artifact-store'
        AWS_REGION  = 'us-east-1'
        ACCOUNT_ID  = '235721456806'
        IMAGE_NAME  = 'java-ci-app'
        IMAGE_TAG   = "${BUILD_NUMBER}"
        ECR_REPO    = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sivareddy-thummuri/Github-Actions.git'
            }
        }

        stage('Build') {
            steps {
                dir('java-ci-app') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Upload to S3') {
            steps {
                sh '''
                    JAR_FILE=$(ls java-ci-app/target/*.jar | head -n 1)
                    aws s3 cp "$JAR_FILE" s3://${S3_BUCKET}/java-ci-app/build-${BUILD_NUMBER}.jar
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:latest -f dockerfile .
                    docker tag ${IMAGE_NAME}:latest ${ECR_REPO}:${IMAGE_TAG}
                    docker tag ${IMAGE_NAME}:latest ${ECR_REPO}:latest
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REPO}:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Build, S3 upload, Docker build, and ECR push completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
        always {
            archiveArtifacts artifacts: 'java-ci-app/target/*.jar', fingerprint: true
        }
    }
}
