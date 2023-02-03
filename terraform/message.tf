resource "aws_sns_topic" "sns_topic_name" {
  name = var.topic_name
}

resource "aws_sqs_queue" "sqs_queue_name" {
  name = "sqs-extract-report-glue"
}

resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  topic_arn = "${aws_sns_topic.sns_topic_name.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sqs_queue_name.arn}"
}

  