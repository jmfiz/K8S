# k8s-ubuntu-singlenode

This docker allow to run kubernetes services on a single container (which is acting both as master and minion).
 
It contains the following components:
- Ubuntu 14.04
- Last version of Docker
- Supervisor
- Wrapdocker (to support docker in docker)
- Kubernetes from binaries (v0.14.0)
- Etcd from binaries (v2.0.5)
- Go lang (v1.3.3)

##Quickstart

Build the image:
```bash
docker build -t k8s-ubuntu-singlenode .
```
then run:
```bash
docker run --privileged -t -i --net="host" k8s-ubuntu-singlenode
```
Or run the image without building:
```bash
docker run --privileged -t -i --net="host" jmfiz/k8s-ubuntu-singlenode
```
All necesary kubernetes services are started, so you can then use kubernetes locally.

##Warning About Disk Usage

A volume its created at /var/lib/docker to host all inner Docker data (images, containers, etc.). When run docker rm volumes are not cleaned up, so disk space could be reduced nesting many Dockers within each other.
