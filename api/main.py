import os
import boto3
import awsgi

from flask import (
  Flask,
  make_response,
  request,
  jsonify
)
from flask_httpauth import HTTPTokenAuth

from modules.user import User
from modules.exceptions import NotFoundException

API_SECRET_TOKEN = os.getenv('API_SECRET_TOKEN')
API_STAGE = os.getenv('API_STAGE', 'development')
is_development = (API_STAGE == 'development')

print(f'Running on Stage => {API_STAGE}')

app = Flask(__name__)
auth = HTTPTokenAuth('Token')

app.config["DEBUG"] = is_development

# on production we will use the credentials from the Lambda's IAM role itself
if is_development:
  dynamodb_client = boto3.client('dynamodb',
    aws_access_key_id=os.environ.get('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.environ.get('AWS_SECRET_ACCESS_KEY'),
    region_name=os.environ.get('AWS_DEFAULT_REGION', 'sa-east-1'),
    endpoint_url=os.environ.get('DYNAMODB_ENDPOINT_URL', 'http://dynamo-db:8000'),
  )
else:
  dynamodb_client = boto3.client('dynamodb')

user = User(dynamodb_client)

# middleware
@auth.verify_token
def verify_token(token):
  return token == API_SECRET_TOKEN

# healthcheck (no authorization)
@app.route('/health', methods=['GET'])
def health():
  response = jsonify(
    data='Health'
  )

  return make_response(response, 200) # ok

# user endpoints
@app.route('/user', methods=['GET'])
@auth.login_required
def find():
  response = jsonify(
    data=user.find()
  )

  return make_response(response, 200) # ok

@app.route('/user/<string:unique_id>', methods=['GET'])
@auth.login_required
def findOne(unique_id):
  try:
    response = jsonify(
      data=user.findOne(unique_id)
    )

    return make_response(response, 200) # ok

  except NotFoundException:
    return make_response({'message': 'Not Found'}, 404) # not found

  except Exception:
    return make_response({'message': 'Internal Server Error'}, 500) # internal server error

@app.route('/user', methods=['POST'])
@auth.login_required
def save():
  body = request.get_json()

  name = body.get('name')
  email = body.get('email')

  try:
    response = jsonify(
      data={"unique_id": user.save(name, email)}
    )

    return make_response(response, 201) # created

  except Exception:
    return make_response({'message': 'Internal Server Error'}, 500)

@app.route('/user/<string:unique_id>', methods=['DELETE'])
@auth.login_required
def delete(unique_id):
  try:
    response = jsonify(
      data=user.delete(unique_id)
    )

    return make_response(response, 204) # no content

  except Exception:
    return make_response({'message': 'Internal Server Error'}, 500)

@app.route('/user/<string:unique_id>', methods=['PUT'])
@auth.login_required
def update(unique_id):
  body = request.get_json()

  name = body.get('name')
  email = body.get('email')

  try:
    response = jsonify(
      data=user.update(unique_id, name, email)
    )

    return make_response(response, 202) # accepted

  except Exception:
    return make_response({'message': 'Internal Server Error'}, 500)

# handler for Lambda Function
def handler(event, context):
  print(event)
  print(context)

  return awsgi.response(app, event, context)

def run(app) -> None:
  app.run(host='0.0.0.0', port='5050')

if __name__ == '__main__' and is_development:
  run(app)
