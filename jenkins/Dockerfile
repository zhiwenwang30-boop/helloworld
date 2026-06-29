FROM docker.m.daocloud.io/library/docker:29-cli AS docker-cli

FROM docker.m.daocloud.io/jenkins/jenkins:lts-jdk17

USER root

# Install git from Debian repo and copy a matching Docker CLI from the official
# Docker CLI image. The Jenkins container talks to the host Docker daemon through
# the mounted /var/run/docker.sock.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker

COPY jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
