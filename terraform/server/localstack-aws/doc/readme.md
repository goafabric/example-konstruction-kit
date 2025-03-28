# docs
https://docs.localstack.cloud/user-guide/integrations/aws-cli/
https://docs.localstack.cloud/user-guide/aws/feature-coverage/
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources

# installation
pip install awscli && pip install awscli-local
docker run --rm --name localstack -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack:4.2.0

# export
export AWS_DEFAULT_REGION="eu-central-1"

# s3 bucket
awslocal s3api create-bucket --bucket sample-bucket2 --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION
awslocal s3api list-buckets

curl http://s3.eu-central-1.es.localhost.localstack.cloud:4566/sample-bucket2  #

curl http://localstack.cloud:4566/sample-bucket2


# sqs
awslocal sqs create-queue --queue-name localstack-queue
awslocal sqs list-queues
                                  
# elasticsearch 
awslocal es create-elasticsearch-domain --domain-name goafabric
curl http://goafabric.eu-central-1.es.localhost.localstack.cloud:4566

# identity and access management
awslocal iam create-user --user-name test
awslocal iam create-access-key --user-name test
              
# api gateway
awslocal apigateway create-rest-api --name 'API Gateway Lambda integration'
awslocal apigateway get-resources --rest-api-id <REST_API_ID>

# lambda
see lambda folder for nodejs example

## pro features only
# eks
https://docs.localstack.cloud/user-guide/aws/eks/
        
# kafka
https://docs.localstack.cloud/user-guide/aws/msk/     

# postgres
https://docs.localstack.cloud/user-guide/aws/rds/#postgresql-engine

