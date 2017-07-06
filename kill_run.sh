#!/bin/bash

ps x|grep /bin/bash|grep -v grep|awk '{print $1}'|xargs kill -9 
ps x|grep /bin/bash

