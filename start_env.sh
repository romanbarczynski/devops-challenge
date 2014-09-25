#!/bin/bash

set -e

start_venv() {
    virtualenv venv --python=python2
    venv/bin/pip install -r requirements.txt
}

get_redis() {
	mkdir -p redis
	cd redis
	test -f redis-2.8.17.tar.gz || wget http://download.redis.io/releases/redis-2.8.17.tar.gz
	tar xzf redis-2.8.17.tar.gz
	cd redis-2.8.17
	make
	cp src/redis-server ../
	cd ../../
}

test -d ./venv/ || start_venv
test -x redis/redis-server || get_redis

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
