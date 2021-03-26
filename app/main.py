import os
import awsgi
from flask import (
    Flask,
    jsonify,
)
from flask_httpauth import HTTPTokenAuth

app = Flask(__name__)
auth = HTTPTokenAuth('Token')

APP_SECRET_TOKEN = os.getenv('APP_SECRET_TOKEN')
print(APP_SECRET_TOKEN)

@auth.verify_token
def verify_token(token):
  return token == APP_SECRET_TOKEN

@app.route('/', methods=['GET'])
@auth.login_required
def index():
  return jsonify(
    status=200,
    message='OK'
  )

def handler(event, context):
  print(event)
  print(context)

  return awsgi.response(app, event, context)
