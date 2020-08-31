import os
import flask
from os import environ
from flask import request, jsonify

##HOSTNAME = os.environ.get('HOSTNAME')

app = flask.Flask(__name__)
app.config["DEBUG"] = True
app.config['HOSTNAME'] = environ.get('HOSTNAME')

@app.route('/', methods=['GET'])
def probe():
   return 'Probe OK'

@app.route('/greetings', methods=['GET'])
def message():
    return 'Hello World from ' + app.config['HOSTNAME']

@app.route('/square', methods=['POST'])
def square():
    if request.method == 'POST':
        number = int(request.json['number'])
        operation = eval("number * number")
        return jsonify(square=operation)
    else:
        return 'Error!'
    
app.run(host='0.0.0.0')
