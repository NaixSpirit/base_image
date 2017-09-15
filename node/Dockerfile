ARG VERSION=latest

FROM node:$VERSION-slim

ARG VERSION
ARG MAINTAINER

LABEL maintainer=$MAINTAINER

COPY sources.list /etc/apt/

RUN apt-get update \
    && apt-get install -qq -y --no-install-recommends git-core \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*
