FROM docker.m.daocloud.io/jenkins/jenkins:lts-jdk17

USER root

# Install docker CLI + git from Debian repo to avoid download.docker.com dependency.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git docker.io \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
