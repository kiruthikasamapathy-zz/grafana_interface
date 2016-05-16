# MAINTAINER Kiru Samapathy <kiru.samapathy@iag.com.au>

# Project name
PROJECT=grafana_interface

ifdef bamboo_working_directory
MOUNT_DIR = $(bamboo_working_directory)
else
MOUNT_DIR = $ (PWD)
endif

all: test build

clean:
	rm -rf build

copy: clean
	mkdir -p build
	cp src/templates/Dockerfile.tmpl build/Dockerfile
	cp -r src/bash/. build/.
	cp -r src/config/. build/.
	cp -r src/dashboards/ build/.
	cp -r src/scripts/ build/.

test: copy
	bundle exec rspec --format documentation

build:
