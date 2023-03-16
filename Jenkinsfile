try {
          node(env.WORKER_NODE) {
            stage('App git checkout') {
              env.CURRENT_STAGE = env.STAGE_NAME
              dir ("${env.COMPONENT_DIRECTORY}") {
                checkout scm: [
                  $class: 'GitSCM',
                  branches: [[name: "${env.BRANCH}"]],
                  extensions: [
                    [$class: 'CleanCheckout'],
                    [$class: 'WipeWorkspace'],
                    [$class: 'LocalBranch', localBranch: "**"]
                  ],
                  userRemoteConfigs: [[
                      credentialsId: "${env.HESI_BUILDER_SECRET_ID}", 
                      url: "https://github.com/${GITHUB_OWNER}/${REPO}.git"
                  ]]
                ]
              }
            }
            stage('Cleanup Workspace') {
              env.CURRENT_STAGE = env.STAGE_NAME
              cleanWs notFailBuild: true
            }
            currentBuild.result = 'SUCCESS'
          }
        }
catch (err) {
    if ("${err}".startsWith('org.jenkinsci.plugins.workflow.steps.FlowInterruptedException') || 
        ("${err}".startsWith('hudson.AbortException') && "${err}".contains('script returned exit code 143')) ) {
        currentBuild.result = 'ABORTED'
    }
    else {
        currentBuild.result = 'FAILURE'
    }
    throw err
}
// finally {
//     slackNotifier(currentBuild.result)
//     echo 'done'
// }


// checkout(
//     [
//         $class: 'GitSCM',
//         extensions: [
//             [
//                 $class: "PreBuildMerge",
//                 options: [
//                     mergeTarget: "master",
//                     fastForwardMode: "FF",
//                     mergeRemote: "origin",
//                     mergeStrategy: "RECURSIVE_THEIRS"
//                 ],
//             ],
//             [
//                 $class: 'UserIdentity',
//                 email: 'user@company.com',
//                 name: 'user123'
//             ],
//         ],
//     ]
// )