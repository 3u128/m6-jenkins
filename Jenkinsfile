pipeline {
    agent { node { label 'linux_oci' } }
    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                docker run --rm -i hadolint/hadolint < Dockerfile
            }
        }
    }
}
