#!/bin/bash
# Installing GO Lang

if [ -z "$1" ]; then
    GO_VERSION="1.24.1"
else
    GO_VERSION=$1
fi

echo "Installing GO Lang - $GO_VERSION"

apt update && apt install wget curl tar -y
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
tar -xf go$GO_VERSION.linux-amd64.tar.gz -C /usr/local
echo 'export PATH=$PATH:/usr/local.go/bin' >> /etc/profile

# Installing Air
source /etc/profile

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH


echo 'export GOROOT=/usr/local/go' >> /root/.bashrc
echo 'export GOPATH=$HOME/go' >> /root/.bashrc
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> /root/.bashrc

rm -rf go$GO_VERSION.linux-amd64.tar.gz 



source /etc/profile
source /root/.bashrc
source ~/.profile
go install github.com/air-verse/air@latest
