#!/bin/bash

if [ ! -d ./package ]; then
  echo "Package doesn't exist, creating..."
  mkdir -p ./package
  pip install -r requirements.txt --target ./package
fi

cd ./package

# cria um zip na pasta anterior
zip -r ../app.zip .
cd ../

# adiciona o main.py no zip
zip -g app.zip main.py

# permissões para ser lido
chmod 755 app.zip

# mover para a pasta do terraform
mv ./app.zip ../terraform/
# cd ../terraform
