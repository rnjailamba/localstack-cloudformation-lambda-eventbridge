# localstack-cloudformation-lambda-eventbridge

System information
1. `aws --version`
`aws-cli/1.19.54 Python/3.9.4 Darwin/19.4.0 botocore/1.20.54`
2. `awslocal --version`
`aws-cli/1.19.54 Python/3.9.4 Darwin/19.4.0 botocore/1.20.54`

Steps to reproduce the issue
1. `docker-compose --env-file .env up -d` with the .env file only consisting of the API Key
2. Run `sh ./1-cloudformation-deploy.sh` to create cloudformation stack and deploy locally
3. Copy the name of the function 'XYZ' (find name of function by `awslocal lambda list-functions --region us-east-1 --query 'Functions[].FunctionName'`
) and invoke the created function by
```
awslocal lambda invoke \
--function-name 'XYZ' \
--region us-east-1 \
--invocation-type Event \
--payload '{ "key": "value" }' \
response.json; 
```
4. Check localstack logs to see an `Invoke Error, "statusCode":500`
5. This happened on line 35 of `atmProducer/handler.js` which puts an event
  `const result = await eventbridge.putEvents(params).promise()`
for eventbridge initialised as
```const eventbridge = new AWS.EventBridge({
    endpoint: 'http://localhost:4566'
  }
)```
