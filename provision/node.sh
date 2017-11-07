#!/bin/bash

# Install test version of docker engine, also shell completions
apt-get install -y -q wget tree ipvsadm
apt-get update
apt-get upgrade

# (ljubon) - Per Docker docc: Install packages to allow apt to use a repository over HTTPS
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# [COMMENTED ]Install test version of docker version, also shell completition
# [COMMENTED] curl -fsSL https://test.docker.com/ | sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update -y
apt-get install -y docker-ce

# Add vagrant user to docker group
usermod -aG docker vagrant

# Configure the docker engine
# Daemon options: https://docs.docker.com/engine/reference/commandline/dockerd/
# Set both unix socket and tcp to make it easy to connect both locally and remote
# You can add TLS for added security (docker-machine does this automagically)
cat > /etc/docker/daemon.json <<END
{
    "hosts": [ 
        "unix://",
        "tcp://0.0.0.0:2375"
    ],
    "experimental": true,
    "debug": true,
    "metrics-addr": "0.0.0.0:9323" 
}
END


# You can't pass both CLI args and use the daemon.json for parameters, 
# so I'm using the RPM systemd unit file because it doesn't pass any args 
# This version changes the following as of 17.03:
#  - Removes Requires=docker.socket
#  - Removes docker.socket from After
#  - Sets LimitNOFILE=infinity
#  - Removes -H fd:// from ExecStart 
# [COMMENTED] wget -O /lib/systemd/system/docker.service https://raw.githubusercontent.com/docker/docker/v17.03.0-ce/contrib/init/systemd/docker.service.rpm
systemctl daemon-reload
systemctl restart docker

apt-get install -y python python-pip
pip install docker-compose
echo $(docker-compose -v)

