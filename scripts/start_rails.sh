#!/bin/bash

rm -f tmp/pids/server.pid && bundle exec RUBYOPT='-W:no-deprecated -W:no-experimental' rails s -b 0.0.0.0
