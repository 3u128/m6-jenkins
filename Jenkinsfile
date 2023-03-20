pipeline {
    agent { node { label 'linux_oci' } }
    
    environment {
        GITHUB_OWNER = "3u128"
        REPO = "m6-jenkins"
        BRANCH = "dev"
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
                  dir('merge') {
                    sh 'git config --global credential.helper cache'
                    sh 'git config --global push.default simple'
                    checkout([$class: 'GitSCM',
                      branches: [[name: "refs/heads/${env.BRANCH}"]],
                      extensions: [
                          // [$class: 'CleanCheckout'],
                          // [$class: 'WipeWorkspace'],
                          [$class: "UserIdentity",
                              name: "Yevhen Lytviak",
                              email: "ylytviak@gmail.com"
                          ],
                          [$class: "PreBuildMerge",
                              options: [
                                  mergeTarget: "main",
                                  fastForwardMode: "FF",
                                  mergeRemote: "origin",
                                  mergeStrategy: "DEFAULT"
                                  ]
                          ],
                      ],
                      userRemoteConfigs: [[url: "https://github.com/${env.GITHUB_OWNER}/${env.REPO}.git"]]])
                    // sh "git checkout main" 
                    sh 'pwd'
                    sh 'git checkout main"'
                    sh "git config --global user.email 'Yevhen'"
                    sh "git config --global user.name 'ylytviak@gmail.com'"
                    sh 'git push origin HEAD'
                  }
                }
 
                failure {
                  sh 'echo failed'
                }
              }
        }
    }
}