// Generated with smithy-dart 0.3.0. DO NOT MODIFY.

/// # Amazon CloudWatch Logs
///
/// You can use Amazon CloudWatch Logs to monitor, store, and access your log files from EC2 instances, CloudTrail, and other sources. You can then retrieve the associated log data from CloudWatch Logs using the CloudWatch console, CloudWatch Logs commands in the Amazon Web Services CLI, CloudWatch Logs API, or CloudWatch Logs SDK.
///
/// You can use CloudWatch Logs to:
///
/// *   **Monitor logs from EC2 instances in real-time**: You can use CloudWatch Logs to monitor applications and systems using log data. For example, CloudWatch Logs can track the number of errors that occur in your application logs and send you a notification whenever the rate of errors exceeds a threshold that you specify. CloudWatch Logs uses your log data for monitoring so no code changes are required. For example, you can monitor application logs for specific literal terms (such as "NullReferenceException") or count the number of occurrences of a literal term at a particular position in log data (such as "404" status codes in an Apache access log). When the term you are searching for is found, CloudWatch Logs reports the data to a CloudWatch metric that you specify.
///
/// *   **Monitor CloudTrail logged events**: You can create alarms in CloudWatch and receive notifications of particular API activity as captured by CloudTrail. You can use the notification to perform troubleshooting.
///
/// *   **Archive log data**: You can use CloudWatch Logs to store your log data in highly durable storage. You can change the log retention setting so that any log events older than this setting are automatically deleted. The CloudWatch Logs agent makes it easy to quickly send both rotated and non-rotated log data off of a host and into the log service. You can then access the raw log data when you need it.
library amplify_logging_cloudwatchlogs_dart.cloud_watch_logs;

export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/cloud_watch_logs_client.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/data_already_accepted_exception.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/input_log_event.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/invalid_parameter_exception.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/invalid_sequence_token_exception.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/put_log_events_request.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/put_log_events_response.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/rejected_log_events_info.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/resource_not_found_exception.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/service_unavailable_exception.dart';
export 'package:amplify_logging_cloudwatchlogs_dart/src/sdk/src/cloud_watch_logs/model/unrecognized_client_exception.dart';
