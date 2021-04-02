import os
import awsgi
from flask import (
    Flask,
    jsonify,
)
from flask_httpauth import HTTPTokenAuth

app = Flask(__name__)
auth = HTTPTokenAuth('Token')

API_SECRET_TOKEN = os.getenv('API_SECRET_TOKEN')
print(API_SECRET_TOKEN)

@auth.verify_token
def verify_token(token):
  return token == API_SECRET_TOKEN

@app.route('/', methods=['GET'])
@auth.login_required
def index():
  return jsonify(
    status=200,
    message='OK'
  )

@app.route('/health', methods=['GET'])
@auth.login_required
def health():
  return jsonify(
    status=200,
    message='Health'
  )

def handler(event, context):
  print(event)
  print(context)

  return awsgi.response(app, event, context)
