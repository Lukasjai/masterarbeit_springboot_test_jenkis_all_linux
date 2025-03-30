#!/bin/bash

set -e

ENV=$1

if [ -z "$ENV" ]; then
  echo "Kein Environment angegeben. Nutzung: ./deploy.sh [dev|test|prod]"
  exit 1
fi

# set app name
case "$ENV" in
  dev)
    APP_NAME="dev-jenkins8105"
    ;;
  test)
    APP_NAME="test-jenkins8103"
    ;;
  prod)
    if [ -z "$APP_NAME" ]; then
      echo " APP_NAME für Produktion nicht gesetzt!"
      exit 1
    fi
    ;;
  *)
    echo "Ungültiges Environment: $ENV"
    exit 1
    ;;
esac

echo " Deploying to Heroku environment: $ENV (App: $APP_NAME)"

# Tag and Push of Docker-Images
docker tag Lukasjai/masterarbeit_springboot_test_jenkis_all_linux:latest registry.heroku.com/$APP_NAME/web
docker push registry.heroku.com/$APP_NAME/web

# trigger Heroku-Release
heroku container:release web --app $APP_NAME

echo "Deployment erfolgreich abgeschlossen für $ENV"
