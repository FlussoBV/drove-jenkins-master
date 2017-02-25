FROM jenkinsci/jenkins:2.47-alpine

MAINTAINER Joost van der Griendt <joostvdg@gmail.com>
LABEL authors="Joost van der Griendt <joostvdg@gmail.com>"
LABEL version="1.0.0"
LABEL description="Docker container for Jenkins Masters For Flusso Drove'"

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY plugins.txt /plugins.txt
RUN /usr/local/bin/plugins.sh /plugins.txt
RUN echo 2.47 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
ENV JENKINS_OPTS "$JENKINS_OPTS --prefix=/jenkins"
