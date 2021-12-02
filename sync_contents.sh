#!/bin/sh -ue

## required tomlq in yq. Try `apt install jq` and `pip3 install yq`
STACK_NAME=`tomlq -r .default.deploy.parameters.stack_name samconfig.toml`
AWS_REGION=`tomlq -r .default.deploy.parameters.region samconfig.toml`
export AWS_REGION
export AWS_PAGER=""

getStackOutput() {
	query=".Stacks[0].Outputs[]|select(.OutputKey==\"$1\").OutputValue"
	aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r "$query"
}

S3Bucket=$(getStackOutput 'S3Bucket')

aws s3 sync contents "s3://$S3Bucket/" \
   --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
