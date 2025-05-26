#!/bin/bash

which jq > /dev/null 2>&1 || (echo "'jq' is not installed, unable to format"; exit 1)

cat tokens.json | jq > tmp
mv tmp tokens.json
