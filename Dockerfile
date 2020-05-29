FROM puneethn/terraform-test-workhorse:0.12.25

WORKDIR /go/src/github.com/comtravo/terraform-aws-lambda
COPY . .
