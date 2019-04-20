#!/usr/bin/env python3
import sys
import boto3
import botocore

BUCKET_NAME = 'csc4006benchbucket' # replace with your bucket name
KEY = sys.argv[1] # replace with your object key

s3 = boto3.resource('s3')

try:
    s3.Bucket(BUCKET_NAME).download_file(KEY, sys.argv[2])
except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == "404":
        print("The object does not exist.")
    else:
        raise
