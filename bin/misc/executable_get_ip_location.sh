#!/bin/bash
curl -s ipinfo.io | jq '.loc' | sed -e 's/,/:/' | sed -e 's/"//g'
