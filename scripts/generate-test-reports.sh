#!/bin/sh

aws s3 cp s3://gp-dev-test-data-bucket/test-results test-results --recursive
allure generate test-results -o test-report
aws s3 cp --recursive ./test-report s3://gp-dev-test-data-bucket/test-report