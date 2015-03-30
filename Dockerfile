FROM ubuntu:14.04
MAINTAINER jmfiz <jmfiz@paradigmatecnologico.com>

# Install Docker
RUN \
    apt-get update && \
    apt-get install -q -y wget git curl && \
    wget -qO- https://get.docker.com/ | sh

# Install kubernetes
WORKDIR /repos
RUN git clone https://github.com/GoogleCloudPlatform/kubernetes.git

# Install golang
RUN \
    wget https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.3.3.linux-amd64.tar.gz
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin

# Install etcd
RUN \
    /repos/kubernetes/hack/travis/install-etcd.sh && \
    cp -rf /repos/kubernetes/third_party/etcd/* /usr/bin/

RUN \
    apt-get update && \
    apt-get install -q -y gcc

# Start supervisord
CMD ["/repos/kubernetes/hack/local-up-cluster.sh"]
