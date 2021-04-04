# Flask API

## About

> This is a simple users API with some CRUD, using DynamoDB

Take a look at the [Swagger](./swagger.yaml) for the specifications

## Testing the API

```bash
export API_SECRET_TOKEN=a80ac2ff00a5468da81693a27e0c4ebf

# healthcheck, no authorization
curl --silent \
  --url "http://localhost:5050/health"

# user endpoints
# save
curl --silent \
  -X POST \
  -H "Authorization: Token $API_SECRET_TOKEN" \
  -H "Content-Type: application/json" \
  --data-raw '{"name": "julio cesar", "email": "julio@mail.com"}' \
  --url "http://localhost:5050/user"
# {
#   "data": {
#     "unique_id": "4cbce695-3e20-40d4-8c06-1baaaacec896"
#   }
# }

# find
curl --silent \
  -X GET \
  -H "Authorization: Token $API_SECRET_TOKEN" \
  -H "Content-Type: application/json" \
  --url "http://localhost:5050/user"
# {
#   "data": [
#     {
#       "email": "julio@mail.com",
#       "name": "julio cesar",
#       "unique_id": "4cbce695-3e20-40d4-8c06-1baaaacec896"
#     }
#   ]
# }

# findOne
curl --silent \
  -X GET \
  -H "Authorization: Token $API_SECRET_TOKEN" \
  -H "Content-Type: application/json" \
  --url "http://localhost:5050/user/4cbce695-3e20-40d4-8c06-1baaaacec896"
# {
#   "data": {
#     "email": "julio@mail.com",
#     "name": "julio cesar",
#     "unique_id": "4cbce695-3e20-40d4-8c06-1baaaacec896"
#   }
# }

# delete
curl --silent \
  -X DELETE -i \
  -H "Authorization: Token $API_SECRET_TOKEN" \
  -H "Content-Type: application/json" \
  --url "http://localhost:5050/user/4cbce695-3e20-40d4-8c06-1baaaacec896"
# HTTP/1.0 204 NO CONTENT
# Content-Type: application/json

# update
curl --silent \
  -X PUT -i \
  -H "Authorization: Token $API_SECRET_TOKEN" \
  -H "Content-Type: application/json" \
  --data-raw '{"name": "julio cesar", "email": "juliocesar@mail.com"}' \
  --url "http://localhost:5050/user/4cbce695-3e20-40d4-8c06-1baaaacec896"
# {
#   "data": {
#     "email": "juliocesar@mail.com",
#     "name": "julio cesar",
#     "unique_id": "4cbce695-3e20-40d4-8c06-1baaaacec896"
#   }
# }
```
