#!/bin/bash
wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest