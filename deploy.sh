#!/bin/bash

set -e
ENV=$1

# .env einlesen
if [ -f .env ]; then
  source .env
else
  echo ".env file not found!"
  exit 1
fi

if [ -z "$ENV" ]; then
  echo "No environment set. use: ./deploy.sh [dev|test|prod]"
  exit 1
fi

# set app name
case "$ENV" in
  dev)
    APP_NAME="$DEV_APP_NAME"
    ;;
  test)
    APP_NAME="$TEST_APP_NAME"
    ;;
  prod)
    APP_NAME="$PROD_APP_NAME"
    if [ -z "$APP_NAME" ]; then
      echo "APP_NAME for production not set!"
      exit 1
    fi
    ;;
  *)
    echo "Invalid environment: $ENV"
    exit 1
    ;;
esac

echo "Set Heroku-Stack to 'container' "
heroku stack:set container --app "$APP_NAME"

echo " Deploying to Heroku environment: $ENV (App: $APP_NAME)"

# Tag and Push of Docker-Images
docker tag Lukasjai/masterarbeit_springboot_test_jenkis_all_linux:latest registry.heroku.com/$APP_NAME/web
docker push registry.heroku.com/$APP_NAME/web



# trigger Heroku-Release
heroku container:release web --app $APP_NAME

echo "Deployment successful for $ENV  → $APP_NAME"
