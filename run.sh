#!/bin/bash
# 1 = config, 2 = context
JENKINS_CONTAINER=jks
JENKINS_IMAGE=jks:latest

RUNNING=`docker ps | grep -c $JENKINS_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[Jenkins] Stopping $JENKINS_CONTAINER"
   docker stop $JENKINS_CONTAINER  >> cow.log 2>&1
fi

EXISTING=`docker ps -a | grep -c $JENKINS_CONTAINER`
if [ $EXISTING -gt 0 ]
then
   echo "[Jenkins] Removing $JENKINS_CONTAINER"
  docker rm $JENKINS_CONTAINER  >> cow.log 2>&1
fi

echo "[Jenkins] Running $JENKINS_CONTAINER"
docker run --name $JENKINS_CONTAINER  \
  -v /etc/localtime:/etc/localtime \
  -p 8088:8080 \
  -e TRY_UPGRADE_IF_NO_MARKER=true \
  -e JAVA_OPTS='-Duser.timezone=Europe/Amsterdam' \
  -d ${JENKINS_IMAGE} 

echo "[Jenkins] Tail the logs of the new instance"
sleep 10
docker logs $JENKINS_CONTAINER 
RUNNING=`docker ps | grep -c $JENKINS_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[Jenkins] $JENKINS_CONTAINER is up"
else
   echo "[Jenkins] $JENKINS_CONTAINER is down"
fi