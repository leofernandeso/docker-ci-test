import redis
import sys
from flask import Flask

app = Flask(__name__)

@app.route('/crash')
def crash():
    raise NameError
    sys.exit()

@app.route('/writedb')
def write_db():
    r = redis.Redis(host='redis-server', port=6379, db=0)
    r.set('foo', 'bar')
    result = r.get('foo')
    return result

@app.route('/')
def hello_world():
    return "Hello World! Hallo Welt!"

app.run(host='0.0.0.0', port=80)
