# -*- coding: utf-8 -*- vim: set ts=4 sw=4 et :

from flask import Flask, request
import redis
app = Flask(__name__)
redis = redis.StrictRedis()

@app.route('/<name>', methods=['GET', 'POST'])
def counter(name):
    if request.method == 'POST' and 'incrBy' in request.form:
        return str(redis.incr(name, request.form['incrBy']))
    return redis.get(name) or '0'


if __name__ == '__main__':
    app.debug = True
    app.run(port=8080)
