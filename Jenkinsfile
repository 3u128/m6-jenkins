// properties([pipelineTriggers([githubPush()])])
pipeline {
    agent { node { label 'linux_oci' } }
    environment {
        GITHUB_OWNER = "3u128"
        REPO = "m6-jenkins"
        BASE = "main"
        HEAD = "dev"
        BRANCH_TO_PROTECT = "main"
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
                    withCredentials([usernamePassword(credentialsId: 'm6-github-app',
                                                    usernameVariable: 'GITHUB_APP',
                                                    passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {
                    sh '''curl -s -L \
                        -X DELETE \
                        -H "Accept: application/vnd.github+json" \
                        -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN"\
                        -H "X-GitHub-Api-Version: 2022-11-28" \
                        https://api.github.com/repos/$GITHUB_OWNER/$REPO/branches/$BRANCH_TO_PROTECT/protection

                        echo "Delete branch $BRANCH_TO_PROTECT"

                        curl -L \
                        -X POST \
                        -H "Accept: application/vnd.github+json" \
                        -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN"\
                        -H "X-GitHub-Api-Version: 2022-11-28" \
                        https://api.github.com/repos/$GITHUB_OWNER/$REPO/merges \
                        --data '{
                        "base": "dev",
                        "head": "feature",
                        "commit_message": "curl merge"
                        }'
                        echo curl merge from $HEAD to $BASE
                        '''
                    slackSend color: "good", message: "Job name: $JOB_NAME\n Branch name: $BRANCH_NAME\n Git commit: $GIT_COMMIT\n Node labels: $NODE_LABELS\n Build number: $BUILD_NUMBER"
                    }
                  }

 
                failure {
                    sh 'echo lint failed'
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
                                }'
                            '''
                    }
                    slackSend color: "danger", message: "Failure.\n Job name: $JOB_NAME\n Branch name: $BRANCH_NAME\n Git commit: $GIT_COMMIT\n Node labels: $NODE_LABELS\n Build number: $BUILD_NUMBER"
                }
            }
        }
        stage('Test') {
            when {
                branch "dev"
            }
            steps {
                sh 'echo "some test"'
            }
            post {
                success {
                    withCredentials([usernamePassword(credentialsId: 'm6-github-app',
                                                    usernameVariable: 'GITHUB_APP',
                                                    passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {
                    sh '''
                        curl -L \
                        -X POST \
                        -H "Accept: application/vnd.github+json" \
                        -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN"\
                        -H "X-GitHub-Api-Version: 2022-11-28" \
                        https://api.github.com/repos/$GITHUB_OWNER/$REPO/merges \
                        --data '{
                        "base": "main",
                        "head": "dev",
                        "commit_message": "curl merge"
                        }'
                        '''
                    slackSend color: "good", message: "Job name: $JOB_NAME\n Branch name: $BRANCH_NAME\n Git commit: $GIT_COMMIT\n Node labels: $NODE_LABELS\n Build number: $BUILD_NUMBER"
                    }
                  }

 
                failure {
                  sh 'echo lint failed'
                  slackSend color: "danger", message: "Job name: $JOB_NAME\n Branch name: $BRANCH_NAME\n Git commit: $GIT_COMMIT\n Node labels: $NODE_LABELS\n Build number: $BUILD_NUMBER"
                }
            }
        }
        stage('main') {
                when {
                    branch "main"
                }
                steps {
                    sh 'echo "main"'
                }
                post {
                    always {
                        slackSend color: "warning", message: "changes in main"
                    }
                }
            }
    }
}
