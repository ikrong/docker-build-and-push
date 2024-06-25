FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ARG TARGETOS
ARG TARGETARCH

ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true
ENV PATH=$PATH:$NVM_DIR/current/bin

ENV GO_VERSION=1.21.11
ENV NODE_VERSION=18

COPY ./install.sh /install.sh

RUN /install.sh
