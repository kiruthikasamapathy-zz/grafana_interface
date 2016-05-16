#! /usr/bin/env bash

if [[ $# -eq 0 ]] ;
then
  printf "Missing arguments\n\n";
  printf "Options are:\n";
  printf "build \nspec \ninstall \ndev \n";
fi

while [[ $# -gt 0 ]] ;
do
  opt="$1";
  shift; #expose next argument
  case $opt in
    build)
      docker build -t test build/.
      ;;
    spec)
      bundle exec rspec --format documentation
      ;;
    install)
      bundle install
      ;;
    dev)
      ./go install spec
      docker run -d --name grafana-interface-dev grafana-interface-spec:latest
      ;;
    temp)
      ./go install spec
      docker ps | awk '{print $1}' | xargs -I {} docker stop {}
      docker ps -a | awk '{print $1}' | xargs -I {} docker rm {}
      docker run -d -p 3000:3000 grafana-interface-spec:latest
      docker ps | awk '{print $1}' | xargs -I {} docker exec -ti {} /bin/bash
      ;;
    *)
      echo "Unknown arg: $opt"; exit 1
      ;;
  esac
done
