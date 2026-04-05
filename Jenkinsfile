pipeline {
    agent any

    environment {
        S3_BUCKET = 'jenkins-s3-artifact-store'
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
                    echo "Uploading $JAR_FILE to S3..."
                    aws s3 cp "$JAR_FILE" s3://${S3_BUCKET}/java-ci-app/build-${BUILD_NUMBER}.jar
                '''
            }
        }
    }

    post {
        success {
            echo 'Build and S3 upload completed successfully'
        }
        failure {
            echo 'Build or S3 upload failed'
        }
        always {
            archiveArtifacts artifacts: 'java-ci-app/target/*.jar', fingerprint: true
        }
    }
}
