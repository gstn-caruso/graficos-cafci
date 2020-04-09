#!/bin/bash

rm -f tmp/pids/server.pid && RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec rails s -b 0.0.0.0
