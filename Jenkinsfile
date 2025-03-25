pipeline {
  agent any
  environment {
    HEROKU_API_KEY = credentials('heroku-lukasjai')
  }
  parameters {
    string(name: 'APP_NAME', defaultValue: '', description: 'Please enter Heroku app name!')
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
    stage('Push to Heroku registry') {
      steps {
        sh '''
                  docker tag Lukasjai/masterarbeit_springboot_test_jenkis_all_linux:latest registry.heroku.com/$APP_NAME/web
                  docker push registry.heroku.com/$APP_NAME/web
                '''
      }
    }
    stage('Release the image') {
      steps {
        sh '''
             heroku stack:set container --app=$APP_NAME
             heroku container:release web --app=$APP_NAME
        '''           }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
