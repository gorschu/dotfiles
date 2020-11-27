#!/bin/bash

pass show email-groupware-sync/fastmail.com/gordon@gordonschulz.de |
    grep Caldav | sed -r 's/.*: (.*)$/\1/'
