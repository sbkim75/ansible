#!/bin/sh

ps -ef | grep CFAgent | grep -v grep | awk '{ print "kill -9 " $2 }' | /bin/sh