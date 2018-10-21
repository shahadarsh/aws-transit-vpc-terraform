resource "aws_iam_role" "iam_cisco_configurator_lambda" {
  name = "iam_cisco_configurator_lambda"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cisco_config_function_role_policy" {
  name        = "cisco_config_function_role_policy"
  path        = "/"
  description = "Cisco Config Function Role Policy"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DetachNetworkInterface",
            "ec2:DeleteNetworkInterface"
         ],
         "Resource":"*"
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cisco_config_role_policy_attachment" {
    role       = "${aws_iam_role.iam_cisco_configurator_lambda.name}"
    policy_arn = "${aws_iam_policy.cisco_config_function_role_policy.arn}"
}

resource "aws_lambda_function" "cisco-configurator" {
  description      = "Transit VPC: This function is invoked when a generic VPN configuration is placed in an S3 bucket - it converts the generic information into Cisco IOS specific commands and pushes the config to transit VPC routers."
  filename         = "transit_vpc_push_cisco_config.zip"
  function_name    = "cisco-configurator"
  role             = "${aws_iam_role.iam_cisco_configurator_lambda.arn}"
  handler          = "transit_vpc_push_cisco_config/lambda_function.lambda_handler"
  source_code_hash = "${base64sha256(file("transit_vpc_push_cisco_config.zip"))}"
  runtime          = "python2.7"
  timeout          = "300"
  memory_size      = "128"
 
  vpc_config {
    subnet_ids = ["${module.transit-vpc.public_subnets}"]
    security_group_ids = ["${module.csr_sg.this_security_group_id}"]
  }
  
  environment {
    variables = {
      CONFIG_FILE = "transit_vpc_config.txt"
      LOG_LEVEL   = "INFO"
    }
  }
}
