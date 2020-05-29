pipeline {

  agent { label 'worker' }

  options {
    ansiColor('gnome-terminal')
    buildDiscarder(logRotator(numToKeepStr: '30'))
    skipDefaultCheckout()
    timestamps()
  }

  stages {
    stage("Checkout SCM") {
      steps {
        script {
          ctCheckout(revision: getMultiBranchName(), wipeWorkspace: true, noTags: true, url: 'git@github.com:comtravo/terraform-aws-lambda.git')
        }
      }
    }

    stage("Build and Test") {
      steps {
        script {
          try {
            sh(label: 'Building docker image', script: "make build")
            sh(label: 'Testing docker image', script: "make test-docker")
          } finally {
            sh(label: 'Cleanup', script: "make clean-all")
          }
        }
      }
    }
  }
}
