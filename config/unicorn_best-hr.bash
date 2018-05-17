#!/bin/sh

### BEGIN INIT INFO
# Provides:          unicorn_best-hr
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the unicorn app server
# Description:       starts unicorn using start-stop-daemon
### END INIT INFO

set -e

USAGE="Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"

# app settings
USER="zerro"
APP_NAME="best-hr"
APP_ROOT="/webhome/$APP_NAME"
ENV="production"

# environment settings
PATH="/home/$USER/.rbenv/shims:/home/$USER/.rbenv/bin:$PATH"
UNICORN_OPTS="-D -E $ENV -c $APP_ROOT/config/unicorn.rb"
GEM_HOME="/home/zerro/.rvm/gems/ruby-2.5.1@rails5"
SET_PATH="cd $APP_ROOT; rvm use ruby-2.5.1@rails5; export GEM_HOME=$GEM_HOME"
CMD="$SET_PATH; $GEM_HOME/bin/unicorn $UNICORN_OPTS"

PID="$APP_ROOT/tmp/pids/unicorn.pid"
OLD_PID="$PID.oldbin"

# make sure the app exists
cd $APP_ROOT || exit 1

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $OLD_PID && kill -$1 `cat $OLD_PID`
}

case $1 in
  start)
    sig 0 && echo >&2 "Already running" && exit 0
    echo "Starting $APP_NAME"
    su - $USER -c "$CMD"
    ;;
  stop)
    echo "Stopping $APP_NAME"
    sig QUIT && exit 0
    echo >&2 "Not running"
    ;;
  force-stop)
    echo "Force stopping $APP_NAME"
    sig TERM && exit 0
    echo >&2 "Not running"
    ;;
  restart|reload|upgrade)
    sig USR2 && echo "reloaded $APP_NAME" && exit 0
    echo >&2 "Couldn't reload, starting '$CMD' instead"
    $CMD
    ;;
  rotate)
    sig USR1 && echo rotated logs OK && exit 0
    echo >&2 "Couldn't rotate logs" && exit 1
    ;;
  *)
    echo >&2 $USAGE
    exit 1
    ;;
esac