FROM ruby:2.7.1-slim
MAINTAINER gstn.caruso@gmail.com.com

ARG INSTALL_PATH=/opt/app
ENV INSTALL_PATH $INSTALL_PATH

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -y nodejs yarn && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /app
RUN useradd devuser && chown -R devuser /app
USER devuser

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

WORKDIR $INSTALL_PATH

COPY . ./
