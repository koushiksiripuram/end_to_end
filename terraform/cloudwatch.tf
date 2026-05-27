resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name = "ghost-app-high-cpu"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 120

  statistic = "Average"

  threshold = 80

  alarm_description = "EC2 CPU usage too high"

  dimensions = {

    InstanceId = aws_instance.ghost_server.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "status_check" {

  alarm_name = "ghost-app-status-check"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "StatusCheckFailed"

  namespace = "AWS/EC2"

  period = 60

  statistic = "Maximum"

  threshold = 0

  alarm_description = "EC2 status check failed"

  dimensions = {

    InstanceId = aws_instance.ghost_server.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}