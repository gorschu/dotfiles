#!/bin/bash

pass show email-groupware-sync/fastmail.com/gordon@gordonschulz.de |
    grep Carddav | sed -r 's/.*: (.*)$/\1/'
