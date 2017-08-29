ARG VERSION=latest

FROM ruby:$VERSION-slim

ARG VERSION
ARG MAINTAINER

LABEL maintainer=$MAINTAINER

COPY sources.list /etc/apt/

RUN apt-get update \
    && apt-get install -qq -y --no-install-recommends curl \
    && curl -sL https://deb.nodesource.com/setup_6.x | sh - \
    && apt-get install -qq -y --no-install-recommends build-essential \
               build-essential \
               nodejs \
               libmysqlclient-dev \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*
