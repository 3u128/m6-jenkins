pipeline {
    agent { node { label 'linux_oci' } }
    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
            }
        }
    }
}
