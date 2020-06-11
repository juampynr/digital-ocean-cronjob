FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    curl \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://github.com/digitalocean/doctl/releases/download/v1.45.1/doctl-1.45.1-linux-amd64.tar.gz | tar -xzv
RUN chmod +x ./doctl
RUN mv ./doctl /usr/local/bin/doctl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.3/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
