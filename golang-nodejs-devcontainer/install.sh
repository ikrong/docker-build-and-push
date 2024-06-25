#!/usr/bin/env bash

set -e

echo "::group::Installing Go tools"

GO_PATH="$GOPATH"

# install go 1.21.11
wget -q -O /tmp/go.tar.gz https://go.dev/dl/go$GO_VERSION.linux-$TARGETARCH.tar.gz
tar -C /usr/local -xzf /tmp/go.tar.gz
rm -rf /tmp/go.tar.gz
go version

# install go tools
export GOPATH=/tmp/gotools
export GOCACHE=/tmp/gotools/cache

mkdir -p $GOCACHE $GO_PATH/bin

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

mv /tmp/gotools/bin/* $GO_PATH/bin/

cd /tmp/

curl -fsSL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | \
sh -s -- -b "${GO_PATH}/bin" "v1.59.1"

echo "::endgroup::"

# install nodejs

echo "::group::Installing Node.js"

updaterc() {
    local _bashrc
    local _zshrc
    _bashrc=/etc/bash.bashrc
    _zshrc=/etc/zsh/zshrc
    echo "Updating ${_bashrc} and ${_zshrc}..."
    if [[ "$(cat ${_bashrc})" != *"$1"* ]]; then
        echo -e "$1" >> "${_bashrc}"
    fi
    if [ -f "${_zshrc}" ] && [[ "$(cat ${_zshrc})" != *"$1"* ]]; then
        echo -e "$1" >> "${_zshrc}"
    fi
}

mkdir -p $NVM_DIR

export PROFILE=/dev/null
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source "${NVM_DIR}/nvm.sh"

nvm_rc_snippet="$(cat << EOF
export NVM_DIR="${NVM_DIR}"
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && . "\$NVM_DIR/bash_completion"
EOF
)"
updaterc "${nvm_rc_snippet}"

nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default

echo "::endgroup::"

rm -rf /tmp/gotools