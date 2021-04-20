STACK_NAME=test9
BUCKET_ID=$(dd if=/dev/random bs=8 count=1 2>/dev/null | od -An -tx1 | tr -d ' \t\n')
BUCKET_NAME_LOCAL=lambda-artifacts-$BUCKET_ID
echo $BUCKET_NAME_LOCAL > bucket-name-local.txt
aws s3 mb s3://$BUCKET_NAME_LOCAL --region us-east-1 --endpoint-url=http://localhost:4566

# BUCKET_NAME_LOCAL=lambda-artifacts-123456789
# aws s3 mb s3://lambda-artifacts-123456789 --region us-east-1

# aws cloudformation package \
# --endpoint-url=http://localhost:4566 \
# --template template.yml \
# --s3-endpoint-url=http://localhost:4566 \
# --s3-bucket $BUCKET_NAME_LOCAL \
# --output-template-file out.yml \
# --region us-east-1

awslocal cloudformation package \
--template template.yml \
--s3-endpoint-url=http://localhost:4566 \
--s3-bucket $BUCKET_NAME_LOCAL \
--output-template-file out.yml \
--region us-east-1

awslocal cloudformation deploy --template-file out.yml --stack-name $STACK_NAME --region us-east-1

aws s3 rm s3://$BUCKET_NAME_LOCAL --recursive --region us-east-1 --endpoint-url=http://localhost:4566
aws s3 rb s3://$BUCKET_NAME_LOCAL --region us-east-1 --endpoint-url=http://localhost:4566