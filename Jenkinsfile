properties([pipelineTriggers([githubPush()])])
pipeline {
    agent { node { label 'linux_oci' } }
    
    environment {
        GITHUB_OWNER = "3u128"
        REPO = "m6-jenkins"
        BASE = "dev"
        HEAD = "feature"
        PRIVATE_TOKEN = credentials('m6-github-secret')
        //TOKEN = credentials("github-secret-m6")
        // SLACK_CHANNEL = "#deployment-notifications"
        // SLACK_TEAM_DOMAIN = "MY-SLACK-TEAM"
        // SLACK_TOKEN = credentials("slack_token")
        // DEPLOY_URL = "https://deployment.example.com/"
    }

    stages {
        stage('Lint') {
            steps {
                sh 'echo "lint by hadolint"'
                //sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
            }
            post {
                success {

                    sh """
                    curl --request POST \
                    --url https://api.github.com/repos/${GITHUB_OWNER}/${REPO}/merges \
                    --header 'authorization: token ${PRIVATE_TOKEN}' \
                    --header 'content-type: application/json' \
                    --data '{
                      "base": "${BASE}",
                      "head": "${HEAD}",
                      "commit_message": "curl merge"
                    }'
                    """
                    sh 'echo curl merge from ${HEAD} to ${BASE}'
                  }

 
                failure {
                  sh 'echo failed'
                }
            }
        }
    }
}