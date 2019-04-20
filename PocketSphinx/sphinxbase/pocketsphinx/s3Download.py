#!/usr/bin/env python3
import sys # system functionality to accept paramter input
import boto3 # AWS utility
import botocore  #Core functionalirt for exception handling

#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: s3Download.py
#
# Purpose: This component downloads an asset from an S3 bucket.
#
#########################################################################################################################

# initialise the bucket and object key values
s3_bucket = 'csc4006benchbucket' # replace with bucket name
obj_key = sys.argv[1] # replace with object key

# initialise the s3 resource using boto
s3 = boto3.resource('s3')

# try except block to handle exceptions
try:
	# download the file based on a provided object key from the S3 bucket
    s3.Bucket(s3_bucket).download_file(obj_key, sys.argv[2])
# exception handling 	
except botocore.exceptions.ClientError as e:
    # if e = ERROR 404 = Not Found
	# This occurs when the object key does not exist in the S3 bucket, print an informative user message informing the user, else the error will be raised
	if e.response['Error']['Code'] == "404":
        print("The object does not exist in the S3 bucket.")
    else:
        raise
