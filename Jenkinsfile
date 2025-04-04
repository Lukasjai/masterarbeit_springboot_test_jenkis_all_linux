pipeline {
  agent any
  environment {
    HEROKU_API_KEY = credentials('heroku-lukasjai')
  }
  triggers {
    cron('30 14 * * *')
  }
  parameters {
    string(name: 'APP_NAME', defaultValue: '', description: 'Please enter Heroku app name!')
        booleanParam(name: 'DEPLOY_PROD', defaultValue: false, description: 'Manueller Trigger für Prod Deployment')
  }
  stages {
    stage('Build') {

      steps {
         sh 'docker build -t Lukasjai/masterarbeit_springboot_test_jenkis_all_linux:latest .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $HEROKU_API_KEY | docker login --username=_ --password-stdin registry.heroku.com'
      }
    }

  stage('Deploy to Dev') {
        when {
          anyOf {
                   triggeredBy 'SCMTrigger'
                   triggeredBy 'TimerTrigger'
                 }
        }
        steps {
          echo "Deploying to Dev environment..."
          sh './deploy.sh dev'
        }
      }

  stage('Deploy to Test') {
        when {
          allOf {
            branch 'main'
            not { triggeredBy 'TimerTrigger' }
          }
        }
        steps {
              echo "Detected merge from development → Deploying to test"
              sh './deploy.sh test'
          }
       }


  stage('Deploy to Prod') {
        when {
          expression { return params.DEPLOY_PROD == true }
        }
        steps {
          echo "Deploying to Production environment..."
          sh './deploy.sh prod'
        }
      }
    }

}
