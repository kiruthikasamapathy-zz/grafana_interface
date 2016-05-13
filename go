#! /usr/bin/env bash

while [[ $# -gt 0 ]] ;
do
  opt="$1";
  shift;              #expose next argument
  case $opt in
    build)
      docker build -t $IMAGE_NAME:$TAGNAME build/.
      ;;
    spec)
      bundle exec rspec --format documentation
      ;;
    install)
      bundle install --path=/usr/lib/anyenv/envs/rbenv/versions/2.2.2/lib/ruby/
      ;;
    *)
      echo "Unknown arg: $opt"; exit 1
      ;;
  esac
done
