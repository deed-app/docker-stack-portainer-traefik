# Docker Portainer Traefik Stack Template

***THIS IS UNDER DEVELOPMENT. NOT READY FOR PRODUCTION YET***

## Goal

This is a Docker Cloud stack template for deploying Portainer and Traefik in a Docker Swarm node.

## Services

- Traefik in Swarm Mode
- - Global replication
- - Uses the "proxy" overlay network
- Portainer Agent
- - Global replication
- - Uses the "agents" overlay network
- Portainer GUI
- - One replica on the Swarm manager node
- - Uses both "proxy" and "agents" overlay networks
- Whoami
- - An example container behind the Traefik LB

## Install

Your Docker host must be in swarm mode.

### Create portainer and traefik data volumes

```
docker volume create portainer_data
docker volume create traefik_data
```

### Create overlay networks for Portainer's agents, and overall Traefik proxy

```
docker network create -d overlay --attachable agents
docker network create -d overlay --attachable proxy
```

### Create the stack

```
docker stack deploy -c docker-cloud.yml gogson-stack
```