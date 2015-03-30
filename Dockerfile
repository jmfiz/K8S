FROM ubuntu:14.04
MAINTAINER jmfiz <jmfiz@paradigmatecnologico.com>

# Install Docker
RUN \
	apt-get update && \
    wget -qO- https://get.docker.com/ | sh

# Install kubernetes and golang
WORKDIR /repos
RUN git clone https://github.com/GoogleCloudPlatform/kubernetes.git
RUN wget https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.3.3.linux-amd64.tar.gz
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin

# Install etcd
WORKDIR /repos/kubernetes
RUN hack/travis/install-etcd.sh
RUN cp third_party/etcd/* /usr/bin/

# Start supervisord
CMD ["/repos/kubernetes/hack/local-up-cluster.sh"]