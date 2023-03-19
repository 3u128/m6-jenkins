pipeline {
    agent { node { label 'linux_oci' } }
    
    environment {
        GITHUB_OWNER = "3u128"
        REPO = "m6-jenkins"
        BRANCH = "feature"
        CREDS_REPO = credentials('m6-jenkins')
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
                  checkout([$class: 'GitSCM',
                    branches: [[name: "${env.BRANCH}"]],
                    extensions: [
                        [$class: "UserIdentity",
                            name: "Yevhen Lytviak",
                            email: "ylytviak@gmail.com"
                        ],
                        [$class: "PreBuildMerge",
                            options: [
                                mergeTarget: "main",
                                fastForwardMode: "FF",
                                mergeRemote: "origin"                                ]
                        ],
                    ],
                    userRemoteConfigs: [[url: "https://github.com/${env.GITHUB_OWNER}/${env.REPO}.git"]]])
                }
 
                failure {
                  sh 'echo failed'
                }
              }
        }
    }
}