properties([pipelineTriggers([githubPush()])])
pipeline {
    agent { node { label 'linux_oci' } }
    // agent {
    //     docker {
    //         image '3u128/github-app-api:generate-token-env-amd64'
    //         label 'linux_oci'
    //     }
    // }


    environment {
        GITHUB_OWNER = "3u128"
        REPO = "m6-jenkins"
        GITHUB_REPOSITORY = "m6-jenkins"
        BASE = "dev"
        HEAD = "feature"
        // APP_ID = "306245"
        BRANCH_TO_PROTECT = "main"
        // PRIVATE_TOKEN = credentials('m6-github-secret')
        // TOKEN = credentials('m6-github-app-ssh')
        TOKEN = credentials('m6-github-app-ssh-oneline')
        // TOKEN = credentials("github-secret-m6")
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
                // cleanWs()
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
                    withCredentials([usernamePassword(credentialsId: 'm6-github-app',
                                                    usernameVariable: 'GITHUB_APP',
                                                    passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {
                        sh '''curl -s -L \
                            -X PUT \
                            -H "Accept: application/vnd.github+json" \
                            -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN"\
                            -H "X-GitHub-Api-Version: 2022-11-28" \
                            https://api.github.com/repos/$GITHUB_OWNER/$REPO/branches/$BRANCH_TO_PROTECT/protection \
                            -d '{
                                    "enforce_admins": true,
                                    "required_status_checks": null,
                                    "required_pull_request_reviews": {
                                        "required_approving_review_count": 0
                                    },
                                    "restrictions": null
                                }' | jq '.enforce_admins | .enabled')
                            '''
                    }
                    // docker.image('3u128/github-app-api:generate-token-env-amd64').withRun('-e "KEY=${TOKEN}"' + ' OWNER="${GITHUB_OWNER}"' + ' -e APP_ID="${APP_ID}"' + ' GITHUB_REPOSITORY="${REPO}"') {
                    // }    
                    // withCredentials([string(credentialsId: 'm6-github-app-ssh-oneline', variable: 'TOKEN')]) {
                    //     sh 'docker pull 3u128/github-app-api:generate-token-env-amd64'
                    //     sh 'docker run -e OWNER=${GITHUB_OWNER} -e APP_ID=${APP_ID} -e GITHUB_REPOSITORY=${REPO} -e BRANCH_TO_PROTECT=${BRANCH_TO_PROTECT} -e KEY="${TOKEN}" 3u128/github-app-api:generate-token-env-amd64'                        
                    //     sh 'cat ./file'
                    //     // sh './github-app-jwt.sh > jwt_token'
                    //     // sh './get-installation-access-token.sh'
                    //     // sh 'rm ./jwt_token'
                    //     // sh 'echo ${GITHUB_TOKEN}'
                    //     // sh 'echo $GITHUB_TOKEN'
                    //     // sh """curl -s -L \
                    //     //     -X PUT \
                    //     //     -H "Accept: application/vnd.github+json" \
                    //     //     -H "Authorization: Bearer ${GITHUB_TOKEN}"\
                    //     //     -H "X-GitHub-Api-Version: 2022-11-28" \
                    //     //     https://api.github.com/repos/${OWNER}/${REPO}/branches/${BRANCH_TO_PROTECT}/protection \
                    //     //     -d '{
                    //     //             "enforce_admins": true,
                    //     //             "required_status_checks": null,
                    //     //             "required_pull_request_reviews": {
                    //     //                 "required_approving_review_count": 0
                    //     //             },
                    //     //             "restrictions": null
                    //     //         }' | jq '.enforce_admins | .enabled')

                    //     //     echo ".enforce_admins"
                    //     //     """
                    // }
                    // sh 'docker pull 3u128/github-app-api:generate-token-env-amd64'
                    // sh 'docker run -e OWNER=${GITHUB_OWNER} -e APP_ID=${APP_ID} -e GITHUB_REPOSITORY=${REPO} -e BRANCH_TO_PROTECT=${BRANCH_TO_PROTECT} -e KEY="${TOKEN}" 3u128/github-app-api:generate-token-env-amd64'
                    // sh """
                    // """
                    cleanWs()
                }
            }
        }
    }
}