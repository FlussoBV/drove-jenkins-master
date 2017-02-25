#!/bin/bash
# 1 = config, 2 = context
JENKINS_CONTAINER=jenkins-instance
JENKINS_IMAGE=caladreas/drove-jenkins-master
NETWORK=drove-ci
HOMEDIR=/home/user
JENKINS_HOME_DIR=drove-jenkins-data

RUNNING=`docker ps | grep -c $JENKINS_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[DROVE] Stopping $JENKINS_CONTAINER"
   docker stop $JENKINS_CONTAINER  >> cow.log 2>&1
fi

EXISTING=`docker ps -a | grep -c $JENKINS_CONTAINER`
if [ $EXISTING -gt 0 ]
then
   echo "[DROVE] Removing $JENKINS_CONTAINER"
  docker rm $JENKINS_CONTAINER  >> cow.log 2>&1
fi

echo "[DROVE] Running $JENKINS_CONTAINER"
docker run --name $JENKINS_CONTAINER  \
  -v $HOMEDIR/$JENKINS_HOME_DIR:/var/jenkins_home \
  -v /etc/localtime:/etc/localtime \
  -p 50000:50000 \
  --net=$NETWORK --net-alias=$JENKINS_CONTAINER \
  -e TRY_UPGRADE_IF_NO_MARKER=true \
  -e JAVA_OPTS='-Duser.timezone=Europe/Amsterdam' \
  -d ${JENKINS_IMAGE} 

echo "[DROVE] Tail the logs of the new instance"
sleep 10
docker logs $JENKINS_CONTAINER 
RUNNING=`docker ps | grep -c $JENKINS_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[DROVE] $JENKINS_CONTAINER is up"
else
   echo "[DROVE] $JENKINS_CONTAINER is down"
fi