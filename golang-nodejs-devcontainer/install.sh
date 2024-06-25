#!/usr/bin/env bash

set -e

mkdir -p "$GOROOT" "$GOPATH"

# install go 1.21.11
wget -q -O /tmp/go.tar.gz https://go.dev/dl/go$GO_VERSION.linux-$TARGETARCH.tar.gz
tar -C /usr/local -xzf /tmp/go.tar.gz
rm -rf /tmp/go.tar.gz
go version

# install go tools
export GOPATH=/tmp/gotools
export GOCACHE=/tmp/gotools/cache

mkdir -p $GOPATH $GOCACHE

cd /tmp/gotools

GO_TOOLS="\
    golang.org/x/tools/gopls@latest \
    honnef.co/go/tools/cmd/staticcheck@latest \
    golang.org/x/lint/golint@latest \
    github.com/mgechev/revive@latest \
    github.com/go-delve/delve/cmd/dlv@latest \
    github.com/fatih/gomodifytags@latest \
    github.com/haya14busa/goplay/cmd/goplay@latest \
    github.com/cweill/gotests/gotests@latest \
    github.com/josharian/impl@latest"

echo "$GO_TOOLS" | xargs -n 1 go install -v

mv /tmp/gotools/bin/* $GOPATH/bin

rm -rf /tmp

curl -fsSL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | \
sh -s -- -b "${GOPATH}/bin" "v1.59.1"

# install nodejs

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default