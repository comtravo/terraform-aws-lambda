FROM puneethn/terraform-test-workhorse:0.12.29

WORKDIR /go/src/github.com/comtravo/terraform-aws-lambda
COPY . .
