#!/bin/bash

# creates a package folder and install dependencies
if [ ! -d ./package ]; then
  echo "Package doesn't exist, creating..."
  mkdir -p ./package
  pip install -r requirements.txt --target ./package
fi

cd ./package

# creates a .zip on the previous folder
zip -r ../api.zip .
cd ../

# give permissions to be read by group and others, besides of full permission to owner
chmod 755 main.py modules/ modules/*.py

# add the *.py file in the .zip
zip -g api.zip main.py modules/*.py

# give permissions to be read by group and others, besides of full permission to owner
chmod 755 api.zip

# moves the .zip to the terraform's folder
mv ./api.zip ../terraform/
