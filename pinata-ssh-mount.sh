#!/usr/bin/env bash
VOLUME_TYPE=volume # volume, bind
VOLUME_NAME=ssh-agent
HOST_VOLUME_PATH=${HOME}/.pinata-ssh-agent

if [ -e $HOME/.pinata-ssh.env ]; then
    . $HOME/.pinata-ssh.env
fi

if [ ${VOLUME_TYPE} == "volume" ]; then
    VOLUME_MOUNT=$VOLUME_NAME
elif [ ${VOLUME_TYPE} == "bind" ]; then
    VOLUME_MOUNT=$HOST_VOLUME_PATH
else
    echo "Unsupported volume type: ${VOLUME_TYPE}"
    exit 1
fi

echo "-v ${VOLUME_MOUNT}:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent/ssh-agent.sock"
