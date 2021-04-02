#!/bin/bash

# creates a package folder and install dependencies
if [ ! -d ./package ]; then
  echo "Package doesn't exist, creating..."
  mkdir -p ./package
  pip install -r requirements.txt --target ./package
fi

cd ./package

# creates a .zip on the previous folder
zip -r ../app.zip .
cd ../

# add the main.py file in the .zip
zip -g app.zip main.py

# give permissions to be read by group and others, besides of full permission to owner
chmod 755 app.zip

# moves the .zip to the terraform's folder
mv ./app.zip ../terraform/
