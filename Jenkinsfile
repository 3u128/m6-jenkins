properties([pipelineTriggers([githubPush()])])
pipeline {
    agent { node { label 'linux_oci' } }
    
    environment {
        GITHUB_OWNER = "3u128"
        REPO = "m6-jenkins"
        BRANCH = "dev"
        // CREDS_REPO = credentials('m6-jenkins')
        // TOKEN = credentials("github-secret-m6")
        // SLACK_CHANNEL = "#deployment-notifications"
        // SLACK_TEAM_DOMAIN = "MY-SLACK-TEAM"
        // SLACK_TOKEN = credentials("slack_token")
        // DEPLOY_URL = "https://deployment.example.com/"
    }

    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                // sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
            }
            post {
                success {
                    // sh """
                    // curl --request POST \
                    // --url https://api.github.com/repos/3u128/m6-jenkins/merges \
                    // --header 'authorization: token ${TOKEN}' \
                    // --header 'content-type: application/json' \
                    // --data '{
                    //   "base": "main",
                    //   "head": "dev",
                    //   "commit_message": "curl merge"
                    // }'
                    // """
                    sh 'echo "YAY!"'
                  }

 
                failure {
                  sh 'echo failed'
                }
            }
        }
    }
}