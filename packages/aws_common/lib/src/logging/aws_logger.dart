// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';
import 'dart:collection';

import 'package:aws_common/aws_common.dart';
import 'package:aws_common/src/logging/logging_ext.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// The default log level used by [AWSLogger].
const zDefaultLogLevel = LogLevel.info;
String _stateErorrMsgPluginIsRegistered(AWSLogger logger) =>
    'A plugin with same type is already registered to "${logger._toString()}"'
    ' in the same logging hierarchy. Unregister the existing plugin from'
    ' "${logger._toString()}" first and then register the new plugin.';

/// {@template aws_common.logging.aws_logger}
/// A logging utility providing the ability to emit log entries, configure the
/// level at which entries are emitted, and register plugins which can handle
/// log entries as they're emitted.
/// {@endtemplate}
///
/// Plugins are created by implementing [AWSLoggerPlugin] and calling
/// [AWSLogger.registerPlugin] on an [AWSLogger] instance.
///
/// By default, a [SimpleLogPrinter] is registered on the root [AWSLogger]
/// which impacts all child loggers.
class AWSLogger implements Closeable {
  /// Creates a top-level [AWSLogger].
  ///
  /// {@macro aws_common.logging.aws_logger}
  factory AWSLogger([String namespace = rootNamespace]) {
    return activeLoggers[namespace] ??= AWSLogger.protected(namespace);
  }

  /// Creates a detached [AWSLogger] which is not part of the global hierarchy.
  ///
  /// {@macro aws_common.logging.aws_logger}
  AWSLogger.detached([String namespace = 'Detached'])
      : _logger = Logger.detached(namespace);

  /// {@macro aws_common.logging.aws_logger}
  @protected
  AWSLogger.protected(String namespace) : _logger = Logger(namespace) {
    _init(this);
  }

  static bool _initialized = false;
  static void _init(AWSLogger rootLogger) {
    if (_initialized) return;
    _initialized = true;
    hierarchicalLoggingEnabled = true;
    rootLogger.registerPlugin(const SimpleLogPrinter());
  }

  /// The root namespace for all [AWSLogger] instances.
  static const rootNamespace = 'AWS';

  /// The cache of all active loggers by namespace.
  @protected
  @visibleForTesting
  static final Map<String, AWSLogger> activeLoggers = {};

  /// The active plugin subscriptions for this logger and its children.
  final Map<AWSLoggerPlugin, StreamSubscription<LogEntry>> _subscriptions = {};

  final Logger _logger;

  /// Parent of this logger in the logger hierarchy.
  AWSLogger? get _parent {
    return activeLoggers[_logger.parent?.fullName];
  }

  /// Children of this logger in the logger hierarchy.
  List<AWSLogger> get _children {
    final result = <AWSLogger>[];
    for (final child in _logger.children.values) {
      result.add(activeLoggers[child.fullName]!);
    }
    return result;
  }

  /// The namespace of this logger.
  String get namespace => _logger.fullName;

  /// Creates an [AWSLogger] with `this` as the parent.
  AWSLogger createChild(String name) {
    assert(name.isNotEmpty, 'Name should not be empty');
    return AWSLogger('$namespace.$name');
  }

  /// Returns a plugin of type [Plugin] registered to this
  /// logger hierarchy or `null`.
  Plugin? getPlugin<Plugin extends AWSLoggerPlugin>() {
    final registeredPlugin = _parent?.getPlugin<Plugin>();
    return registeredPlugin ??
        _subscriptions.keys
                .firstWhereOrNull((element) => element.runtimeType == Plugin)
            as Plugin?;
  }

  /// configures [AWSLoggerPlugin] for this logger instance.
  void
      configure<Config extends Object?, Plugin extends AWSLoggerPlugin<Config>>(
    AWSLoggerPluginKey<Config, Plugin> pluginKey,
    void Function(Config) fn,
  ) {
    final plugin = getPlugin<Plugin>();
    if (plugin == null) {
      throw StateError('No plugin registered for $pluginKey');
    }
    final config = plugin.configuration;
    fn(config);
  }

  /// Registers an [AWSLoggerPlugin] to handle logs emitted by this logger
  /// instance.
  ///
  /// Throws [StateError] if a plugin with same type is registered to this
  /// logger hierarchy.
  void registerPlugin<T extends AWSLoggerPlugin>(
    T plugin,
  ) {
    if (_subscriptions.keys.any((element) => element.runtimeType == T)) {
      throw StateError(_stateErorrMsgPluginIsRegistered(this));
    }

    final queue = Queue<AWSLogger>();
    if (_parent != null) {
      queue.add(_parent!);
    }

    while (queue.isNotEmpty) {
      final logger = queue.removeFirst();
      if (logger._subscriptions.keys
          .any((element) => element.runtimeType == T)) {
        throw StateError(_stateErorrMsgPluginIsRegistered(logger));
      }
      if (logger._parent != null) {
        queue.add(logger._parent!);
      }
    }

    if (_children.isNotEmpty) {
      queue.addAll(_children);
    }
    while (queue.isNotEmpty) {
      final logger = queue.removeFirst();
      if (logger._subscriptions.keys
          .any((element) => element.runtimeType == T)) {
        throw StateError(_stateErorrMsgPluginIsRegistered(logger));
      }
      if (logger._children.isNotEmpty) {
        queue.addAll(logger._children);
      }
    }

    _subscriptions[plugin] = _logger.onRecord
        .map((record) => record.toLogEntry())
        .listen(plugin.handleLogEntry);
  }

  /// Unregisters [plugin] from this logger instance.
  void unregisterPlugin(AWSLoggerPlugin plugin) {
    final currentSubscription = _subscriptions.remove(plugin);
    if (currentSubscription != null) {
      unawaited(currentSubscription.cancel());
    }
  }

  /// Unregisters all [AWSLoggerPlugin]s on this logger instance.
  void unregisterAllPlugins() {
    for (final subscription in _subscriptions.values) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
  }

  /// The minimum [LogLevel] that will be emitted by the logger.
  LogLevel get logLevel => _logger.level.logLevel;

  set logLevel(LogLevel logLevel) {
    _logger.level = logLevel.level;
  }

  /// Logs a [message] at the given [level].
  void log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.log(level.level, message, error, stackTrace);
  }

  /// Logs a message with level [LogLevel.verbose].
  void verbose(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.finer(message, error, stackTrace);
  }

  /// Logs a message with level [LogLevel.debug].
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /// Logs a message with level [LogLevel.info].
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Logs a message with level [LogLevel.warn].
  void warn(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /// Logs a message with level [LogLevel.error].
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  @override
  void close() => unregisterAllPlugins();

  /// String value of [runtimeType]
  @mustBeOverridden
  String get runtimeTypeName => 'AWSLogger';

  String _toString() {
    return '$runtimeTypeName($namespace)';
  }
}

/// Mixin providing an [AWSLogger] to AWS classes.
mixin AWSLoggerMixin on AWSDebuggable {
  /// The logger for this class.
  AWSLogger get logger => AWSLogger().createChild(runtimeTypeName);
}

/// {@template aws_common.logging.aws_logger_plugin}
/// A plugin to an [AWSLogger] which handles log entries emitted at the
/// [LogLevel] of the logger instance.
/// {@endtemplate}
abstract class AWSLoggerPlugin<Configuration extends Object?> {
  /// {@macro aws_common.logging.aws_logger_plugin}
  const AWSLoggerPlugin();

  /// Handles a log entry emitted by the [AWSLogger].
  void handleLogEntry(LogEntry logEntry);

  /// Configuration for [AWSLoggerPlugin].
  Configuration get configuration;
}

///
class AWSLoggerPluginKey<Config extends Object?,
    Plugin extends AWSLoggerPlugin<Config>> {
  ///
  const AWSLoggerPluginKey();
}

/// An [AWSLoggerPlugin] for sending logs to AWS CloudWatch.
class CloudWatchLoggerPlugin
    extends AWSLoggerPlugin<CloudWatchLoggerPluginConfiguration> {
  ///
  CloudWatchLoggerPlugin({
    required CloudWatchLoggerPluginConfiguration pluginConfig,
    required AWSCredentialsProvider authProvider,
  })  : _pluginConfig = pluginConfig,
        _authProvider = authProvider;

  final CloudWatchLoggerPluginConfiguration _pluginConfig;
  final AWSCredentialsProvider _authProvider;

  static const CloudWatchLoggerPluginKey pluginKey =
      CloudWatchLoggerPluginKey();

  @override
  CloudWatchLoggerPluginConfiguration get configuration {
    return _pluginConfig;
  }

  @override
  void handleLogEntry(LogEntry logEntry) {
    //
  }

  void flushLogs() {}
}

/// A plugin identifier which can be passed to [AWSLogger] `configure`
/// method to retrieve a [CloudWatchLoggerPlugin] plugin wrapper.
class CloudWatchLoggerPluginKey extends AWSLoggerPluginKey<
    CloudWatchLoggerPluginConfiguration, CloudWatchLoggerPlugin> {
  ///
  const CloudWatchLoggerPluginKey();
}

///
class CloudWatchLoggerPluginConfiguration {
  ///
  CloudWatchLoggerPluginConfiguration(
    this.logGroupName,
    this.region,
    this.cacheMaxSizeInMB,
    this.flushIntervalInSeconds,
    this.localLoggingConstraints,
    this.remoteLoggingConstraintsProvider, {
    required bool enable,
  }) : _enabled = enable;

  bool _enabled;

  final String logGroupName;
  final String region;
  final int cacheMaxSizeInMB;
  final Duration flushIntervalInSeconds;
  final CloudWatchLoggingConstraints localLoggingConstraints;
  RemoteLoggingConstraintsProvider? remoteLoggingConstraintsProvider;

  bool get enabled => _enabled;
  CloudWatchLoggingConstraints get loggingConstraints {
    return remoteLoggingConstraintsProvider?.loggingConstraints ??
        localLoggingConstraints;
  }

  void enable() => _enabled = true;
  void disable() => _enabled = false;
}

abstract class RemoteLoggingConstraintsProvider {
  CloudWatchLoggingConstraints? get loggingConstraints;
}

///
class DefaultRemoteLoggingConstraintsProvider
    implements RemoteLoggingConstraintsProvider {
  ///
  DefaultRemoteLoggingConstraintsProvider(
    this.config,
    this.authProviderRepo,
  );

  final DefaultRemoteConfiguration config;
  final AWSCredentialsProvider authProviderRepo;
  @override
  CloudWatchLoggingConstraints? get loggingConstraints {
    CloudWatchLoggingConstraints();
    return null;
  }
}

class CustomRemoteConfigProvider implements RemoteLoggingConstraintsProvider {
  @override
  // TODO: implement loggingConstraints
  CloudWatchLoggingConstraints? get loggingConstraints =>
      throw UnimplementedError();
}

class CloudWatchLoggingConstraints {
  String? defaultLogLevel;
}

class DefaultRemoteConfiguration {
  DefaultRemoteConfiguration(this.endpoint, this.refreshIntervalInSeconds);
  String endpoint;
  Duration refreshIntervalInSeconds;
}

void test() {
  const authProviderRepo = AWSCredentialsProvider(
    AWSCredentials('accessKeyId', 'secretAccessKey'),
  );

  final remoteConfigProvider = DefaultRemoteLoggingConstraintsProvider(
    DefaultRemoteConfiguration('endpoint', Duration.zero),
    authProviderRepo,
  );

  final pluginConfig = CloudWatchLoggerPluginConfiguration(
    enable: true,
    'logGroupName',
    'region',
    5,
    const Duration(minutes: 20),
    CloudWatchLoggingConstraints(),
    remoteConfigProvider,
  );

  final loggerPlugin = CloudWatchLoggerPlugin(
    pluginConfig: pluginConfig,
    authProvider: authProviderRepo,
  );
  final logger = AWSLogger()..registerPlugin(loggerPlugin);
  print('');
  logger.warn('some warn message');
  print('');
  logger.configure(CloudWatchLoggerPlugin.pluginKey, (pluginConfig) {
    pluginConfig.remoteLoggingConstraintsProvider =
        DefaultRemoteLoggingConstraintsProvider(
      DefaultRemoteConfiguration(
        'endpoint',
        const Duration(
          minutes: 20,
        ),
      ),
      authProviderRepo,
    );
  });

  loggerPlugin.configuration.remoteLoggingConstraintsProvider =
      DefaultRemoteLoggingConstraintsProvider(
    DefaultRemoteConfiguration(
      'endpoint',
      Duration.zero,
    ),
    authProviderRepo,
  );

  AWSLogger().registerPlugin(
    CloudWatchLoggerPlugin(
      pluginConfig: pluginConfig,
      authProvider: authProviderRepo,
    ),
  );
}
