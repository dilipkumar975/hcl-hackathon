provider "aws" {
  region = "us-west-1"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "container_lambda" {
  function_name = "my-container-lambda"
  package_type  = "Image"
  image_uri     = "<your-ecr-uri>:latest" # Replace with your actual ECR image URI
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 10
  memory_size   = 128
}
