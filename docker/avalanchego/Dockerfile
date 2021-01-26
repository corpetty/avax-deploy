# syntax=docker/dockerfile:experimental

FROM golang:1.15.5-buster

RUN mkdir -p /go/src/github.com/corpetty

WORKDIR $GOPATH/src/github.com/corpetty/
RUN apt-get update && apt-get install -y \
      build-essential \
      git 

RUN git clone \
      -b master \
      https://github.com/corpetty/avalanchego

WORKDIR $GOPATH/src/github.com/corpetty/avalanchego
CMD "./scripts/build.sh"

