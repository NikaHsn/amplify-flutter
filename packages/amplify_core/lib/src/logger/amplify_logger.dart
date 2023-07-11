// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import 'package:amplify_core/amplify_core.dart';
import 'package:meta/meta.dart';

/// {@macro aws_common.logging.aws_logger}
class AmplifyLogger extends AWSLogger {
  /// Creates a top-level [AmplifyLogger].
  ///
  /// {@macro aws_common.logging.aws_logger}
  factory AmplifyLogger([String namespace = rootNamespace]) {
    // Create a logger inside the Amplify hierarchy so that printing and log
    // level behavior are consistent with public API.
    //
    // Use AWSLogger to create a logger which can have its own hierarchy.
    if (!namespace.startsWith(rootNamespace)) {
      namespace = '$rootNamespace.$namespace';
    }
    return (AWSLogger.activeLoggers[namespace] ??= AmplifyLogger._(namespace))
        as AmplifyLogger;
  }

  /// Creates a [AmplifyLogger] for the Amplify [category].
  ///
  /// {@macro aws_common.logging.aws_logger}
  factory AmplifyLogger.category(Category category) =>
      AmplifyLogger().createChild(category.name);

  AmplifyLogger._(super.namespace) : super.protected();

  /// The root namespace for all [AmplifyLogger] instances.
  static const rootNamespace = '${AWSLogger.rootNamespace}.Amplify';

  @override
  AmplifyLogger createChild(String name) {
    assert(name.isNotEmpty, 'Name should not be empty');
    return AmplifyLogger('$namespace.$name');
  }

  @override
  String get runtimeTypeName => 'AmplifyLogger';
}

/// {@template amplify_core.logger.amplify_logger_plugin}
/// A plugin to an [AmplifyLogger] which handles log entries emitted at the
/// [LogLevel] of the logger instance.
/// {@endtemplate}
abstract class AmplifyLoggerPlugin extends AWSLoggerPlugin {
  /// {@macro amplify_core.logger.amplify_logger_plugin}
  const AmplifyLoggerPlugin();
}

/// Mixin providing an [AmplifyLogger] to Amplify classes.
mixin AmplifyLoggerMixin on AWSDebuggable {
  /// The logger for this class.
  @protected
  AmplifyLogger get logger => AmplifyLogger().createChild(runtimeTypeName);
}

// ignore: avoid_classes_with_only_static_members
class AmplifyLoggingCloudWatch {
  static CloudWatchLoggerPlugin? loggerPlugin;
  static AmplifyLogger logger = AmplifyLogger();

  static void configure(
    LoggingConfig loggingConfig,
    AmplifyAuthProviderRepository authProviderRepo,
  ) {
    if (loggerPlugin != null) {
      return;
    }
    final credentialsProvider = authProviderRepo
        .getAuthProvider(APIAuthorizationType.iam.authProviderToken)!;
    //final identityProvider = authProviderRepo.getAuthProvider(APIAuthorizationType.userPools.authProviderToken);
    final cloudWatchConfig = loggingConfig.cloudWatchConfig!;
    RemoteLoggingConstraintsProvider? remoteProvider;
    if (cloudWatchConfig.defaultRemoteConfiguration != null) {
      final defaultConfig = cloudWatchConfig.defaultRemoteConfiguration!;
      final remoteConfig = DefaultRemoteConfiguration(
        endpoint: defaultConfig.endpoint,
        refreshIntervalInSeconds: defaultConfig.refreshIntervalInSeconds,
      );
      remoteProvider = DefaultRemoteLoggingConstraintsProvider(
        remoteConfig,
        credentialsProvider,
      );
    }
    final config = CloudWatchLoggerPluginConfiguration(
      enable: cloudWatchConfig.enable,
      logGroupName: cloudWatchConfig.logGroupName,
      region: cloudWatchConfig.region,
      cacheMaxSizeInMB: cloudWatchConfig.cacheMaxSizeInMB,
      flushIntervalInSeconds: cloudWatchConfig.flushIntervalInSeconds,
      localLoggingConstraints: cloudWatchConfig.loggingConstraints,
    );

    loggerPlugin = CloudWatchLoggerPlugin(
      pluginConfig: config,
      authProvider: credentialsProvider,
      remoteLoggingConstraintsProvider: remoteProvider,
    );
    logger.registerPlugin(loggerPlugin!);
  }
}

class LoggingConfig {
  LoggingConfig({
    this.cloudWatchConfig,
    this.consoleConfig,
  });
  CloudWatchLoggingPlugin? cloudWatchConfig;
  ConsoleLoggingPlugin? consoleConfig;
}

class ConsoleLoggingPlugin {
  ConsoleLoggingPlugin({this.enable});
  bool? enable;
}

class CloudWatchLoggingPlugin {
  CloudWatchLoggingPlugin(
    this.enable,
    this.logGroupName,
    this.region,
    this.cacheMaxSizeInMB,
    this.flushIntervalInSeconds,
    this.defaultRemoteConfiguration,
    this.loggingConstraints,
  );

  bool enable;
  String logGroupName;
  String region;
  int cacheMaxSizeInMB;
  Duration flushIntervalInSeconds;
  DefaultRemoteConfiguration? defaultRemoteConfiguration;
  CloudWatchLoggingConstraints loggingConstraints;
}
