AWS List S3 Buckets
==================


### AWS List S3 Buckets

Generates a listing of S3 buckets for a given region, key, and secret key

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#!/bin/bash

apt-get update -y
apt-get install python3.6 -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
pip install awscli

sudo mkdir ~/.aws
echo [default] > config
echo aws_access_key_id=<ACCESS_KEY> >> config
echo aws_secret_access_key=<SECRET_KEY> >> config
echo region=us-west-2 >> config
mv config ~/.aws

aws s3 ls
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

