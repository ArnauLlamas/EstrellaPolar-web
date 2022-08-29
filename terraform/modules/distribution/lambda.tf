data "aws_caller_identity" "current" {}

resource "random_pet" "rand" {}

locals {
  lambda_function_name = "cloudfront-modify-headers-${random_pet.rand.id}"
}

data "archive_file" "lambda_zip_inline" {
  type        = "zip"
  output_path = "/tmp/lambda_zip_inline.zip"
  source {
    content  = <<EOF
'use strict';
exports.handler = (event, context, callback) => {
    
  //Get contents of response
  const response = event.Records[0].cf.response;
  const headers = response.headers;

  //Set new headers 
  headers['strict-transport-security'] = [{key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubdomains; preload'}]; 
  headers['content-security-policy'] = [{key: 'Content-Security-Policy', value: "default-src 'none'; img-src 'self'; script-src 'none'; style-src 'self'; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; require-trusted-types-for 'script';"}]; 
  headers['x-content-type-options'] = [{key: 'X-Content-Type-Options', value: 'nosniff'}]; 
  headers['x-frame-options'] = [{key: 'X-Frame-Options', value: 'DENY'}]; 
  headers['x-xss-protection'] = [{key: 'X-XSS-Protection', value: '1; mode=block'}]; 
  headers['referrer-policy'] = [{key: 'Referrer-Policy', value: 'same-origin'}]; 

  //Return modified response
  callback(null, response);
};
EOF
    filename = "index.js"
  }
}

resource "aws_lambda_function" "modify_response_headers_function" {
  provider = aws.us-east-1

  filename         = data.archive_file.lambda_zip_inline.output_path
  source_code_hash = data.archive_file.lambda_zip_inline.output_base64sha256

  handler = "index.handler"
  runtime = "nodejs16.x"
  publish = true

  function_name = local.lambda_function_name
  role          = aws_iam_role.modify_response_headers_function.arn
}

resource "aws_iam_role" "modify_response_headers_function" {
  inline_policy {
    name = "logs"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
          Effect   = "Allow"
          Resource = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.lambda_function_name}:*"
        }
      ]
    })
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "edgelambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_cloudwatch_log_group" "modify_response_headers_function" {
  provider = aws.us-east-1

  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 30
}
