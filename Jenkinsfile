pipeline {
    agent any
    tools { maven 'Maven-3.9' }
    environment {
        TOMCAT_DEPLOY_PATH = '/tomcat_webapps'
        APP_NAME = 'webapp'
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'mvn clean compile'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'mvn test'
            }
            post {
                always { junit '**/target/surefire-reports/*.xml' }
            }
        }
        stage('Package') {
            steps {
                echo 'Packaging...'
                sh 'mvn package -DskipTests'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying to Tomcat...'
                sh """
                    rm -f ${TOMCAT_DEPLOY_PATH}/${APP_NAME}.war
                    rm -rf ${TOMCAT_DEPLOY_PATH}/${APP_NAME}
                    cp target/${APP_NAME}.war ${TOMCAT_DEPLOY_PATH}/
                """
            }
        }
    }
    post {
        success { echo '✅ Pipeline successful!' }
        failure { echo '❌ Pipeline failed!' }
        always { cleanWs() }
    }
}
