# Grafana as Docker container

Runs Grafana dashboard as a Docker container. 
It includes the precanned dashboard configurations and add configuration to connect to InfluxDB during start up.

## [CI]

## Custodian

## Prerequisites

## Local Development

  * `make dev`

    * Runs the unit tests
    * Builds the Docker image locally
    * Starts a container based on the image
    * Open the [dashboard](http://localhost:3000)
    * If using VM/docker-machine use the corresponding host in place of localhost

#### Adding new dashboard

  * Add new dashboard
  * Export dashboard to json format
  * Copy the json file to src/dashboards/

#### Edit exising dashboard

  * Open the Grafana dashboard
  * 'Save as' exising dashboard (the ones rendered based on json) to new dashboard
  * Do your changes
  * Export to json
  * Replace the exising json file at /src/dashboards/

## Testing

  * `make test`

    * Uses Serverspec to run the unit tests
    * Builds a Docker image
    * Deployable as a Docker container
    * Includes the precanned dashboard configurations

## Build

  * `make test`

## Publish

  * `make publish`

## Deploy

#### Caveats

  * The repository has to be created before we can push to private Docker registry

## References
