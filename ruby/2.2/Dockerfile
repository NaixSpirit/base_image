FROM ruby:2.2-slim

LABEL maintainer="hxy <huangxuanyu@fishtrip.cn>"

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
