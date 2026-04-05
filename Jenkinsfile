pipeline {
    agent any

    tools {
        jdk 'Oracle OpenJDK'
        // add maven tool name here only if you configured one in Jenkins Tools
        // maven 'Maven-3.9'
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
    }

    post {
        success {
            echo 'Build completed successfully'
        }
        failure {
            echo 'Build failed'
        }
        always {
            archiveArtifacts artifacts: 'java-ci-app/target/*.jar', fingerprint: true
        }
    }
}
