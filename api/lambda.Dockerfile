FROM python:3.6-alpine AS build

WORKDIR /usr/src/app

RUN mkdir -p ./package

COPY requirements.txt .
RUN pip install -r \
    requirements.txt --no-cache-dir --target ./package

COPY . .

FROM alpine:3.7 AS pack

WORKDIR /usr/src/app

RUN apk add --no-cache zip
COPY --from=build /usr/src/app /usr/src/app

VOLUME ["/lambda"]

ENTRYPOINT [ "/usr/src/app/pack.sh" ]
