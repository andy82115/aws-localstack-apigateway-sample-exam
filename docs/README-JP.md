# インストール方法
1. Makefileのダウンロード（任意）
```
brew install make //for macOS
```
2. .envsampleをenvに変更し、Localstack Auth Tokenを入力する。（任意）
```
LOCALSTACK_AUTH_TOKEN = "setup-your-localstack-auth-token"
```
3. Docker / Docker-Composeのダウンロード
4. awslocal , tflocal , terraformをインストール
5. DockerでLocalstackを実行する
```
make docker-start //for Makefile
docker-compose up -d //for Normal docker compose
```
6. terraform(aws)をlocalstackにデプロイする。
```
make tf-deploy //for Makefile

//for Normal
tflocal -chdir=stage init
tflocal -chdir=stage plan
tflocal -chdir=stage apply --auto-approve
```
7. Apigatewayが正常に動作していることをテストする
```
//for Makefile
make test-secret-get
make test-secret-update

//for Normal, need to get Localstack url link
//check api_url from the output of terraform
//run bellow at Terminal
curl -s -X POST -H 'Content-Type: application/json' -d '{"action":"get"}' http://{INPUT THE URL NUMBER HERE}.execute-api.localhost.localstack.cloud:4566/dev/secret
```

8. Feedback messageを受け取った→成功:tada::tada::tada:

# ルール
-  [Terraform Best Practice](https://www.terraform-best-practices.com/)

# 前提条件
1. make
2. creat .env file
3. tflocal
4. awslocal
5. localstack account (optional)
6. docker / docker-compose
7. awslocal

# そのほか
1. localstack上のawsサービスをチェックする（localstackアカウントを持っていて、.envにLocalstack Auth Tokenを入力している場合）。
 ![locastack img](./docs/localstack-screenshot.png)

2. Awsサービスのロードマップ
![aws flow img](./docs/aws-flow.jpg)

# Todo List
- [X] Add localstack picture
- [X] Add Install docs
- [X] Add Aws Service picture
- [X] Test once