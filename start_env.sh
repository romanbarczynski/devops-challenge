#!/bin/bash

start_venv() {
    virtualenv venv
    venv/bin/pip install -r requirements.txt
}

test -d ./venv/ || start_venv

venv/bin/circusd circus.ini --daemon

# as daemon it exits before waiting for start
sleep 4
