FROM puneethn/terraform-test-workhorse:0.12.25

WORKDIR /go/src/github.com/comtravo/terraform-aws-lambda

RUN apt-get update && apt-get -y install python3 python3-pip
COPY . .
