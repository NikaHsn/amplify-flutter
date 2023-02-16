// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import 'dart:async';
import 'dart:typed_data';

import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_db_common_dart/amplify_db_common_dart.dart'
    as db_common;
import 'package:amplify_storage_s3_dart/amplify_storage_s3_dart.dart';
import 'package:amplify_storage_s3_dart/src/platform_impl/download_file/download_file.dart'
    as download_file_impl;
import 'package:amplify_storage_s3_dart/src/prefix_resolver/storage_access_level_aware_prefix_resolver.dart';
import 'package:amplify_storage_s3_dart/src/storage_s3_service/storage_s3_service.dart';
import 'package:amplify_storage_s3_dart/src/storage_s3_service/transfer/transfer.dart'
    as transfer;
import 'package:amplify_storage_s3_dart/src/utils/app_path_provider/app_path_provider.dart';
import 'package:meta/meta.dart';

/// A symbol used for unit tests.
@visibleForTesting
const zIsTest = #_zIsTest;

bool get _zIsTest => Zone.current[zIsTest] as bool? ?? false;

/// {@template amplify_storage_s3_dart.amplify_storage_s3_plugin_dart}
/// The Dart Storage S3 plugin for the Amplify Storage Category.
/// {@endtemplate}
class AmplifyStorageS3Dart extends StoragePluginInterface<
    S3ListOperation,
    S3ListOptions,
    S3GetPropertiesOperation,
    S3GetPropertiesOptions,
    S3GetUrlOperation,
    S3GetUrlOptions,
    S3UploadDataOperation,
    S3UploadDataOptions,
    S3UploadFileOperation,
    S3UploadFileOptions,
    S3DownloadDataOperation,
    S3DownloadDataOptions,
    S3DownloadFileOperation,
    S3DownloadFileOptions,
    S3CopyOperation,
    S3CopyOptions,
    S3MoveOperation,
    S3MoveOptions,
    S3RemoveOperation,
    S3RemoveOptions,
    S3RemoveManyOperation,
    S3RemoveManyOptions,
    S3Item,
    S3TransferProgress> with AWSDebuggable, AWSLoggerMixin {
  /// {@macro amplify_storage_s3_dart.amplify_storage_s3_plugin_dart}
  AmplifyStorageS3Dart({
    String? delimiter,
    S3PrefixResolver? prefixResolver,
    @visibleForTesting DependencyManager? dependencyManagerOverride,
  })  : _delimiter = delimiter,
        _prefixResolver = prefixResolver,
        dependencyManager = dependencyManagerOverride ?? DependencyManager();

  /// {@template amplify_storage_s3_dart.plugin_key}
  /// A plugin key which can be used with `Amplify.Storage.getPlugin` to retrieve
  /// a S3-specific Storage category interface.
  /// {@endtemplate}
  static const StoragePluginKey<
      S3ListOperation,
      S3ListOptions,
      S3GetPropertiesOperation,
      S3GetPropertiesOptions,
      S3GetUrlOperation,
      S3GetUrlOptions,
      S3UploadDataOperation,
      S3UploadDataOptions,
      S3UploadFileOperation,
      S3UploadFileOptions,
      S3DownloadDataOperation,
      S3DownloadDataOptions,
      S3DownloadFileOperation,
      S3DownloadFileOptions,
      S3CopyOperation,
      S3CopyOptions,
      S3MoveOperation,
      S3MoveOptions,
      S3RemoveOperation,
      S3RemoveOptions,
      S3RemoveManyOperation,
      S3RemoveManyOptions,
      S3Item,
      S3TransferProgress,
      AmplifyStorageS3Dart> pluginKey = _AmplifyStorageS3DartPluginKey();

  final String? _delimiter;

  /// Dependencies of the plugin.
  @protected
  final DependencyManager dependencyManager;

  /// The [S3PluginConfig] of the [AmplifyStorageS3Dart] plugin.
  @protected
  late final S3PluginConfig s3pluginConfig;

  S3PrefixResolver? _prefixResolver;

  /// Gets prefix resolver for testing
  @visibleForTesting
  S3PrefixResolver? get prefixResolver => _prefixResolver;

  /// Gets the instance of dependent [StorageS3Service].
  @protected
  StorageS3Service get storageS3Service => dependencyManager.expect();

  AppPathProvider get _appPathProvider => dependencyManager.getOrCreate();

  @override
  Future<void> configure({
    AmplifyConfig? config,
    required AmplifyAuthProviderRepository authProviderRepo,
  }) async {
    final s3PluginConfig = config?.storage?.awsPlugin;

    if (s3PluginConfig == null) {
      throw ConfigurationError('No Storage S3 plugin config detected.');
    }

    s3pluginConfig = s3PluginConfig;

    final identityProvider = authProviderRepo
        .getAuthProvider(APIAuthorizationType.userPools.authProviderToken);

    if (identityProvider == null) {
      throw const StorageAuthException(
        'No Cognito User Pool provider found for Storage.',
        recoverySuggestion:
            "If you haven't already, please add amplify_auth_cognito plugin to your App.",
      );
    }

    _prefixResolver ??= StorageAccessLevelAwarePrefixResolver(
      delimiter: _delimiter,
      identityProvider: identityProvider,
    );

    final credentialsProvider = authProviderRepo
        .getAuthProvider(APIAuthorizationType.iam.authProviderToken);

    if (credentialsProvider == null) {
      throw const StorageAuthException(
        'No credential provider found for Storage.',
        recoverySuggestion:
            "If you haven't already, please add amplify_auth_cognito plugin to your App.",
      );
    }

    dependencyManager
      ..addInstance<db_common.Connect>(db_common.connect)
      ..addBuilder<AppPathProvider>(S3DartAppPathProvider.new)
      ..addBuilder(
        transfer.TransferDatabase.new,
        const Token<transfer.TransferDatabase>(
          [Token<db_common.Connect>(), Token<AppPathProvider>()],
        ),
      )
      ..addInstance<StorageS3Service>(
        StorageS3Service(
          credentialsProvider: credentialsProvider,
          defaultBucket: s3pluginConfig.bucket,
          defaultRegion: s3pluginConfig.region,
          delimiter: _delimiter,
          prefixResolver: _prefixResolver!,
          logger: logger,
          dependencyManager: dependencyManager,
        ),
      );

    scheduleMicrotask(() async {
      await Amplify.asyncConfig;
      if (_zIsTest) {
        return;
      }
      unawaited(storageS3Service.abortIncompleteMultipartUploads());
    });
  }

  @override
  S3ListOperation list({
    String? path,
    StorageListOptions? options,
  }) {
    final s3Options = S3ListOptions.from(
      options: options,
      accessLevel: s3pluginConfig.defaultAccessLevel,
    );

    return S3ListOperation(
      request: StorageListRequest(
        path: path,
        options: s3Options,
      ),
      result: storageS3Service.list(
        path: path,
        options: s3Options,
      ),
    );
  }

  @override
  S3GetPropertiesOperation getProperties({
    required String key,
    StorageGetPropertiesOptions? options,
  }) {
    final s3Options =
        S3GetPropertiesOptions.from(options, s3pluginConfig.defaultAccessLevel);

    return S3GetPropertiesOperation(
      request: StorageGetPropertiesRequest(
        key: key,
        options: s3Options,
      ),
      result: storageS3Service.getProperties(
        key: key,
        options: s3Options,
      ),
    );
  }

  @override
  S3GetUrlOperation getUrl({
    required String key,
    StorageGetUrlOptions? options,
  }) {
    final s3Options =
        S3GetUrlOptions.from(options, s3pluginConfig.defaultAccessLevel);

    return S3GetUrlOperation(
      request: StorageGetUrlRequest(
        key: key,
        options: s3Options,
      ),
      result: storageS3Service.getUrl(
        key: key,
        options: s3Options,
      ),
    );
  }

  @override
  S3DownloadDataOperation downloadData({
    required String key,
    StorageDownloadDataOptions? options,
    void Function(S3TransferProgress)? onProgress,
  }) {
    final bytes = BytesBuilder();
    final s3Options =
        S3DownloadDataOptions.from(options, s3pluginConfig.defaultAccessLevel);
    final downloadTask = storageS3Service.downloadData(
      key: key,
      options: s3Options,
      onProgress: onProgress,
      onData: bytes.add,
    );

    return S3DownloadDataOperation(
      request: StorageDownloadDataRequest(
        key: key,
        options: s3Options,
      ),
      result: downloadTask.result.then(
        (downloadedItem) => S3DownloadDataResult(
          bytes: bytes.takeBytes(),
          downloadedItem: downloadedItem,
        ),
      ),
      resume: downloadTask.resume,
      pause: downloadTask.pause,
      cancel: downloadTask.cancel,
    );
  }

  @override
  S3DownloadFileOperation downloadFile({
    required String key,
    required AWSFile localFile,
    void Function(S3TransferProgress)? onProgress,
    StorageDownloadFileOptions? options,
  }) {
    final request = StorageDownloadFileRequest(
      key: key,
      localFile: localFile,
      options: options,
    );
    return download_file_impl.downloadFile(
      request: request,
      s3pluginConfig: s3pluginConfig,
      storageS3Service: storageS3Service,
      appPathProvider: _appPathProvider,
      onProgress: onProgress,
    );
  }

  @override
  S3UploadDataOperation uploadData({
    required StorageDataPayload data,
    required String key,
    void Function(S3TransferProgress)? onProgress,
    StorageUploadDataOptions? options,
  }) {
    final s3Options =
        S3UploadDataOptions.from(options, s3pluginConfig.defaultAccessLevel);
    final uploadTask = storageS3Service.uploadData(
      key: key,
      dataPayload: data,
      options: s3Options,
      onProgress: onProgress,
    );

    return S3UploadDataOperation(
      request: StorageUploadDataRequest(
        data: data,
        key: key,
        options: s3Options,
      ),
      result: uploadTask.result.then(
        (uploadedItem) => S3UploadDataResult(uploadedItem: uploadedItem),
      ),
      cancel: uploadTask.cancel,
    );
  }

  @override
  S3UploadFileOperation uploadFile({
    required AWSFile localFile,
    required String key,
    void Function(S3TransferProgress)? onProgress,
    StorageUploadFileOptions? options,
  }) {
    final s3Options =
        S3UploadFileOptions.from(options, s3pluginConfig.defaultAccessLevel);

    final uploadTask = storageS3Service.uploadFile(
      key: key,
      localFile: localFile,
      options: s3Options,
      onProgress: onProgress,
    );

    return S3UploadFileOperation(
      request: StorageUploadFileRequest(
        localFile: localFile,
        key: key,
        options: s3Options,
      ),
      result: uploadTask.result.then(
        (uploadedItem) => S3UploadFileResult(uploadedItem: uploadedItem),
      ),
      resume: uploadTask.resume,
      pause: uploadTask.pause,
      cancel: uploadTask.cancel,
    );
  }

  @override
  S3CopyOperation copy({
    required StorageItemWithAccessLevel<StorageItem> source,
    required StorageItemWithAccessLevel<StorageItem> destination,
    StorageCopyOptions? options,
  }) {
    final s3Source = S3ItemWithAccessLevel.from(source);
    final s3Destination = S3ItemWithAccessLevel.from(destination);
    final s3Options = S3CopyOptions.from(options);

    return S3CopyOperation(
      request: StorageCopyRequest(
        source: s3Source,
        destination: s3Destination,
        options: s3Options,
      ),
      result: storageS3Service.copy(
        source: s3Source,
        destination: s3Destination,
        options: s3Options,
      ),
    );
  }

  @override
  S3MoveOperation move({
    required StorageItemWithAccessLevel<StorageItem> source,
    required StorageItemWithAccessLevel<StorageItem> destination,
    StorageMoveOptions? options,
  }) {
    final s3Source = S3ItemWithAccessLevel.from(source);
    final s3Destination = S3ItemWithAccessLevel.from(destination);
    final s3Options = S3MoveOptions.from(options);

    return S3MoveOperation(
      request: StorageMoveRequest(
        source: s3Source,
        destination: s3Destination,
        options: s3Options,
      ),
      result: storageS3Service.move(
        source: s3Source,
        destination: s3Destination,
        options: s3Options,
      ),
    );
  }

  @override
  S3RemoveOperation remove({
    required String key,
    StorageRemoveOptions? options,
  }) {
    final s3Options =
        S3RemoveOptions.from(options, s3pluginConfig.defaultAccessLevel);

    return S3RemoveOperation(
      request: StorageRemoveRequest(
        key: key,
        options: s3Options,
      ),
      result: storageS3Service.remove(
        key: key,
        options: s3Options,
      ),
    );
  }

  @override
  S3RemoveManyOperation removeMany({
    required List<String> keys,
    StorageRemoveManyOptions? options,
  }) {
    final s3Options =
        S3RemoveManyOptions.from(options, s3pluginConfig.defaultAccessLevel);

    return S3RemoveManyOperation(
      request: StorageRemoveManyRequest(
        keys: keys,
        options: s3Options,
      ),
      result: storageS3Service.removeMany(
        keys: keys,
        options: s3Options,
      ),
    );
  }

  @override
  String get runtimeTypeName => 'AmplifyStorageS3Dart';
}

class _AmplifyStorageS3DartPluginKey extends StoragePluginKey<
    S3ListOperation,
    S3ListOptions,
    S3GetPropertiesOperation,
    S3GetPropertiesOptions,
    S3GetUrlOperation,
    S3GetUrlOptions,
    S3UploadDataOperation,
    S3UploadDataOptions,
    S3UploadFileOperation,
    S3UploadFileOptions,
    S3DownloadDataOperation,
    S3DownloadDataOptions,
    S3DownloadFileOperation,
    S3DownloadFileOptions,
    S3CopyOperation,
    S3CopyOptions,
    S3MoveOperation,
    S3MoveOptions,
    S3RemoveOperation,
    S3RemoveOptions,
    S3RemoveManyOperation,
    S3RemoveManyOptions,
    S3Item,
    S3TransferProgress,
    AmplifyStorageS3Dart> {
  const _AmplifyStorageS3DartPluginKey();

  @override
  String get runtimeTypeName => 'AmplifyStorageS3DartPluginKey';
}
