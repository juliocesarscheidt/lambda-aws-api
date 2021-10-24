# Kinesis

```bash

export STREAM_NAME="kinesis-stream"

# stream
aws kinesis create-stream \
  --stream-name "${STREAM_NAME}" \
  --shard-count 1

aws kinesis list-streams

aws kinesis describe-stream \
  --stream-name "${STREAM_NAME}"


# shards
aws kinesis list-shards \
  --stream-name "${STREAM_NAME}"
{
  "Shards": [
    {
      "ShardId": "shardId-000000000000",
      "HashKeyRange": {
        "StartingHashKey": "0",
        "EndingHashKey": "340282366920938463463374607431768211455"
      },
      "SequenceNumberRange": {
        "StartingSequenceNumber": "49623284608040154138070761974418063071579464115423281154"
      }
    }
  ]
}

# AT_SEQUENCE_NUMBER | AFTER_SEQUENCE_NUMBER | TRIM_HORIZON | LATEST | AT_TIMESTAMP
aws kinesis get-shard-iterator \
  --stream-name "${STREAM_NAME}" \
  --shard-id shardId-000000000000 \
  --shard-iterator-type TRIM_HORIZON
{
  "ShardIterator": "AAAAAAAAAAE2xkZOhTcUXQF8AgdsaGcimMo3OusAMOWC02eXz6cRWnjR5XDTM0IcGq9CcBMbHK30iBwQdiCwXfozmDjMhPKjIHmZsoW6BiCOR5MT6TUrn+ZxDdNJASghxMDINP8tVcEBzoRRO2IfYCYM8kuTVP/7fss/5PA0kAFXpcqxMPix7w5UjMIAxXEMaQ4XMeke2moTf5AX7SEe9qukPBo7d/u0lqy/uNH1yWHnS88BW0Rpig=="
}


# records
aws kinesis put-records \
  --stream-name "${STREAM_NAME}" \
  --records Data="$(echo '{"name": "MESSAGE"}' | base64 -w0)",PartitionKey=key

aws kinesis get-records \
  --shard-iterator "AAAAAAAAAAE2xkZOhTcUXQF8AgdsaGcimMo3OusAMOWC02eXz6cRWnjR5XDTM0IcGq9CcBMbHK30iBwQdiCwXfozmDjMhPKjIHmZsoW6BiCOR5MT6TUrn+ZxDdNJASghxMDINP8tVcEBzoRRO2IfYCYM8kuTVP/7fss/5PA0kAFXpcqxMPix7w5UjMIAxXEMaQ4XMeke2moTf5AX7SEe9qukPBo7d/u0lqy/uNH1yWHnS88BW0Rpig=="



# enable stream from dynamodb to kinesis
aws dynamodb enable-kinesis-streaming-destination \
  --table-name "Users" \
  --stream-arn "arn:aws:kinesis:sa-east-1:000000000000:stream/kinesis-stream"

aws dynamodb describe-kinesis-streaming-destination \
  --table-name "Users"

```
