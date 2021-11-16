#!make

build:
	docker build -t 636553281721.dkr.ecr.us-east-1.amazonaws.com/test-lambda:latest .

login:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 636553281721.dkr.ecr.us-east-1.amazonaws.com/test-lambda

push: login
	docker push 636553281721.dkr.ecr.us-east-1.amazonaws.com/test-lambda:latest
