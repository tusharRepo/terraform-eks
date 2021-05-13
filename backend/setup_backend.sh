#!/bin/bash

export region=$1
stack_name="terraform-backend"

aws cloudformation create-stack --stack-name $stack_name --template-body file://backend.yaml --region $region

while [ `aws cloudformation describe-stacks --stack-name $stack_name  --query 'Stacks[*].StackStatus' --output text --region $region` != "CREATE_COMPLETE" ]
do
    aws cloudformation describe-stacks --stack-name $stack_name  --query 'Stacks[*].StackStatus' --output text --region $region
    echo "waiting for stack creation to complete"
    sleep 20
done

aws cloudformation describe-stacks --stack-name $stack_name  --query 'Stacks[*].StackStatus' --output text --region $region
echo "stack creation completed"

export backend_dynamodb_table=$(aws cloudformation describe-stacks --stack-name $stack_name  --query 'Stacks[*].Outputs[?OutputKey==`TableName`].[OutputValue]' --output text --region $region)

export backend_s3_bucket=$(aws cloudformation describe-stacks --stack-name $stack_name  --query 'Stacks[*].Outputs[?OutputKey==`S3Bucket`].[OutputValue]' --output text --region $region) 

envsubst < backend.tf.tmpl > ../backend.tf