properties([pipelineTriggers([githubPush()])])
pipeline {
    agent { node { label 'linux_oci' } }
    
    environment {
        GITHUB_OWNER = "3u128"
        REPO = "m6-jenkins"
        BASE = "dev"
        HEAD = "feature"
        APP_ID = "306245"
        BRANCH_TO_PROTECT = "main"
        PRIVATE_TOKEN = credentials('m6-github-secret')
        // TOKEN = credentials('m6-github-app-ssh')
        TOKEN = credentials('test-ssh')
        //TOKEN = credentials("github-secret-m6")
        // SLACK_CHANNEL = "#deployment-notifications"
        // SLACK_TEAM_DOMAIN = "MY-SLACK-TEAM"
        // SLACK_TOKEN = credentials("slack_token")
        // DEPLOY_URL = "https://deployment.example.com/"
    }

    stages {
        stage('Lint') {
            when {
                branch "feature"
            }
            steps {
                sh 'echo "lint by hadolint"'
                sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
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
                    sh 'echo lint failed'
                    // sh 'docker run -e OWNER=${GITHUB_OWNER} -e APP_ID=${APP_ID} -e GITHUB_REPOSITORY=${REPO} -e BRANCH_TO_PROTECT=${BRANCH_TO_PROTECT} -v "${TOKEN}":/action/key.pem 3u128/github-app-api:generate-token-amd64'
                    sh 'docker run -e OWNER=${GITHUB_OWNER} -e APP_ID=${APP_ID} -e GITHUB_REPOSITORY=${REPO} -e BRANCH_TO_PROTECT=${BRANCH_TO_PROTECT} -e KEY="${TOKEN}" 3u128/github-app-api:generate-token-env-amd64'
                    // sh """
                    // """
                }
            }
        }
    }
}