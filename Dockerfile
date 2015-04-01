FROM ubuntu:14.04
MAINTAINER jmfiz <jmfiz@paradigmatecnologico.com>

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    wget \
    git \
    curl \
    make \
    supervisor

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

# Supervisor Setup
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install kubernetes
RUN mkdir -p /opt/bin
WORKDIR /repos
RUN \
    wget https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v0.14.0/kubernetes.tar.gz && \
    tar -C /repos -xzf kubernetes.tar.gz && \
    tar -C /repos/kubernetes/server -xzf /repos/kubernetes/server/kubernetes-server-linux-amd64.tar.gz && \
    cp -rf /repos/kubernetes/server/kubernetes/server/bin/* /opt/bin

# Install etcd
RUN \
    wget https://github.com/coreos/etcd/releases/download/v2.0.5/etcd-v2.0.5-linux-amd64.tar.gz && \
    tar -C /usr/local -xzf etcd-v2.0.5-linux-amd64.tar.gz && \
    cp -rf /usr/local/etcd-v2.0.5-linux-amd64/* /opt/bin

# Install golang
RUN \
        wget https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz && \
        tar -C /usr/local -xzf go1.3.3.linux-amd64.tar.gz

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/opt/bin

WORKDIR /repos/kubernetes/cluster/ubuntu
RUN ./util.sh

WORKDIR /

# Define additional metadata for our image.
VOLUME /var/lib/docker

# Start cluster + supervisord
CMD ["supervisord","-c", "/etc/supervisor/supervisord.conf"]

