from uuid import uuid4

from .exceptions import NotFoundException

class User(object):
  def __init__(self, dynamodb_client):
    self.dynamodb_client = dynamodb_client
    self.table_name = 'Users'

  def __format_user(self, user):
    return {
      inner_user: list(user[inner_user].values())[0]
      for inner_user in user.keys()
    }

  def find(self) -> list:
    response = self.dynamodb_client.scan(
      TableName=self.table_name,
    )

    if 'Items' not in response or \
    not response['Items'] or \
    response['Items'] is None:
      return []

    data = []
    items = list(response['Items'])
    for item in items:
      data.append(self.__format_user(item))

    return data

  def findOne(self, unique_id) -> dict:
    response = self.dynamodb_client.get_item(
      Key={
        'unique_id': { 'S': unique_id }
      },
      ReturnConsumedCapacity='TOTAL',
      TableName=self.table_name,
    )

    if 'Item' not in response or \
    not response['Item'] or \
    response['Item'] is None:
      raise NotFoundException('not_found')

    data = {}
    item = dict(response['Item'])
    data = self.__format_user(item)

    return data

  def save(self, name, email) -> str:
    unique_id = str(uuid4())

    response = self.dynamodb_client.put_item(
      Item={
        'unique_id': { 'S': unique_id },
        'name': { 'S': name },
        'email': { 'S': email },
      },
      ReturnConsumedCapacity='TOTAL',
      TableName=self.table_name,
    )

    return unique_id

  def delete(self, unique_id) -> None:
    response = self.dynamodb_client.delete_item(
      Key={
        'unique_id': { 'S': unique_id }
      },
      TableName=self.table_name,
    )

    return None

  def update(self, unique_id, name, email) -> str:
    response = self.dynamodb_client.update_item(
      ExpressionAttributeNames={
        '#N': 'name',
        '#E': 'email',
      },
      ExpressionAttributeValues={
        ':n': {
          'S': name,
        },
        ':e': {
          'S': email,
        },
      },
      Key={
        'unique_id': { 'S': unique_id }
      },
      ReturnValues='ALL_NEW',
      TableName=self.table_name,
      UpdateExpression='SET #N = :n, #E = :e',
    )

    data = {}

    item = dict(response['Attributes'])
    data = self.__format_user(item)

    return data
