FROM grafana/grafana
MAINTAINER Kiru "kirusamapathy"
ARG DEPLOY_ENVIRONMENT
EXPOSE 3000
ENV DEPLOY_ENVIRONMENT=${DEPLOY_ENVIRONMENT}
RUN apt-get update && \
    apt-get -y --no-install-recommends install curl supervisor
COPY etc/. /etc/
COPY defaults.ini /usr/share/grafana/conf/
COPY dashboards/. /var/lib/grafana/dashboards/
COPY scripts/. /usr/share/grafana/scripts/
COPY go /go
RUN chmod 744 /usr/share/grafana/scripts/* && \
    chmod 744 /go

ENTRYPOINT ["/go","start"]
