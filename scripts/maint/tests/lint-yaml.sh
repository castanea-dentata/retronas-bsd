#!/usr/bin/env bash

PROFILE=${1:-min}

if [ ! -x /usr/bin/ansible-lint ]
then
    sudo apt-get install -y ansible-lint
fi

for i in $(ls /usr/local/retronas-bsd/ansible/*.yml); do echo -n "$i: ";ansible-lint --profile=$PROFILE $i; done
