#!/bin/sh

aws sts get-caller-identity
aws s3 cp s3://el8-dev-test-data-bucket/test-results test-results --recursive
allure generate test-results -o test-report