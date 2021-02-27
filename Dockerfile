FROM puneethn/terraform-test-workhorse:0.13.5

WORKDIR /go/src/github.com/comtravo/terraform-aws-lambda
COPY . .
