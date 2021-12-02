# DynamoDB information

> Some commands using local DynamoDB

```bash
# create the table
aws dynamodb create-table \
  --endpoint-url http://localhost:8000 \
  --table-name "Users" \
  --attribute-definitions AttributeName=unique_id,AttributeType=S \
  --key-schema AttributeName=unique_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

# get all data from table
aws dynamodb scan \
  --endpoint-url http://localhost:8000 \
  --table-name "Users"

# create an item
cat << EOF >> user.json
{
  "unique_id": {"S": "1234"},
  "name": {"S": "User 1"},
  "email": {"S": "user1@mail.com"}
}
EOF

aws dynamodb put-item \
  --endpoint-url http://localhost:8000 \
  --table-name "Users" \
  --item file://user.json \
  --return-consumed-capacity TOTAL \
  --return-item-collection-metrics SIZE

# query data from table
aws dynamodb query \
  --endpoint-url http://localhost:8000 \
  --table-name "Users" \
  --key-condition-expression 'unique_id = :v1' \
  --expression-attribute-values '{
    ":v1": {"S":"1234"}
  }'
```
