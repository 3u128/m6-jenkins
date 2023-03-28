properties([pipelineTriggers([githubPush()])])
pipeline {
    agent { node { label 'linux_oci' } }
    
    environment {
        // PRIVATE_TOKEN = credentials('m6-github-secret')
    }

    stages {
        stage('Lint') {
            steps {
                sh 'echo "main"'
            }
            post {
                success {
                    sh 'echo success'
                  }

 
                failure {
                  sh 'echo failed'
                }
            }
        }
    }
}
