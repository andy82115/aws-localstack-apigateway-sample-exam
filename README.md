!!!!　[日本語](./docs/README-JP.md)

# How to install
1. Download Makefile (optional)
```
brew install make //for macOS
```
2. Change .envsample to env and input Localstack Auth Token(optional)
```
LOCALSTACK_AUTH_TOKEN = "setup-your-localstack-auth-token"
```
3. Download Docker / Docker-Compose
4. Install awslocal , tflocal , terraform
5. Run Localstack with Docker
```
make docker-start //for Makefile
docker-compose up -d //for Normal docker compose
```
6. Deploy the terraform(aws) to the localstack
```
make tf-deploy //for Makefile

//for Normal
tflocal -chdir=stage init
tflocal -chdir=stage plan
tflocal -chdir=stage apply --auto-approve
```
7. Test the apigateway is running well
```
//for Makefile
make test-secret-get
make test-secret-update

//for Normal, need to get Localstack url link
//check api_url from the output of terraform
//run bellow at Terminal
curl -s -X POST -H 'Content-Type: application/json' -d '{"action":"get"}' http://{INPUT THE URL NUMBER HERE}.execute-api.localhost.localstack.cloud:4566/dev/secret
```

8. Got feedback message -> success~:tada::tada::tada:

# Build Rule
-  [Terraform Best Practice](https://www.terraform-best-practices.com/)

# Prerequisite tool
1. make
2. creat .env file
3. tflocal
4. awslocal
5. localstack account (optional)
6. docker / docker-compose
7. awslocal

# Other
1. Check aws service on localstack (if you have localstack account and input the Localstack Auth Token on .env )
 ![locastack img](/docs/localstack-screenshot.png)

2. Roadmap of this Aws Service
![aws flow img](/docs/aws-flow.jpg)

# Todo List
- [X] Add localstack picture
- [X] Add Install docs
- [X] Add Aws Service picture
- [X] Test once