#!/bin/bash

COFF='\033[0m'
CBLACK='\033[0;30m'
CRED='\033[0;31m'
CGREEN='\033[0;32m'
CYELLOW='\033[0;33m'
CBLUE='\033[0;34m'
CPURPLE='\033[0;35m'
CCYAN='\033[0;36m'
CWHITE='\033[0;37m'
CGRAY='\033[1;30m'
SED_PATTERN="s/^/$(tput setaf 0)$(tput bold)Docker     : $(tput sgr0) /"
function printf() { builtin printf "${CGRAY}GogsonStack: ${COFF} $1"; }

########################
#### CORE
########################

function configure()
{
    printf "${CGREEN}Creating data volumes${COFF}\n"
    
    docker volume create portainer_data 2>&1 | sed "${SED_PATTERN}"
    docker volume create traefik_data 2>&1 | sed "${SED_PATTERN}"
    docker volume create swarmpit_data 2>&1 | sed "${SED_PATTERN}"

    printf "${CGREEN}Creating networks${COFF}\n"

    docker network create -d overlay --attachable agents 2>&1 | sed "${SED_PATTERN}"
    docker network create -d overlay --attachable proxy 2>&1 | sed "${SED_PATTERN}"
}

function deploy()
{
    if [ ! -f stack-config.env ]; then
        printf "${CRED}No stack-config.env file found${COFF}\n"
        printf "${CRED}Copy the configuration file and edit it${COFF}\n"
        exit 1
    fi

    configure

    printf "${CGREEN}Deploying stack${COFF}\n"
    source stack-config.env && docker stack deploy -c docker-cloud.yml gogson-stack 2>&1 | sed "${SED_PATTERN}"
}

deploy