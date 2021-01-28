{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${aws-region}:${aws-account-id}:log-group:${log-group}",
        "arn:aws:logs:${aws-region}:${aws-account-id}:log-group:${log-group}:log-stream:*"
      ]
    }
  ]
}