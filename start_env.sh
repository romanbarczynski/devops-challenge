#!/bin/bash

set -e

start_venv() {
    virtualenv venv --python=python2
    venv/bin/pip install -r requirements.txt
}

test -d ./venv/ || start_venv

venv/bin/circusd circus.ini --daemon

timeout=5
i=0
while [ $i -le $timeout ]; do
	if curl localhost:8080/ > /dev/null 2>&1 ; then
		echo "Started"
		exit 0
	fi
	sleep 1
	i=$(($i +1))
done

echo "ERROR: did not start in reasonable time ($timeout)"
exit 1
