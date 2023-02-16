// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

part of amplify_interface;

/// {@template amplify_core.amplify_storage_category}
/// The Amplify Storage category provides an interface for interacting with
/// a storage plugin.
///
/// It comes with default, built-in support for Amazon S3 service
/// leveraging Amplify Auth Category for authorization.
///
/// The Amplify CLI helps you to create and configure the storage category
/// and auth category.
/// {@endtemplate}
class StorageCategory<
    PluginStorageListOperation extends StorageListOperation,
    PluginStorageListOptions extends StorageListOptions,
    PluginStorageGetPropertiesOperation extends StorageGetPropertiesOperation,
    PluginStorageGetPropertiesOptions extends StorageGetPropertiesOptions,
    PluginStorageGetUrlOperation extends StorageGetUrlOperation,
    PluginStorageGetUrlOptions extends StorageGetUrlOptions,
    PluginStorageUploadDataOperation extends StorageUploadDataOperation,
    PluginStorageUploadDataOptions extends StorageUploadDataOptions,
    PluginStorageUploadFileOperation extends StorageUploadFileOperation,
    PluginStorageUploadFileOptions extends StorageUploadFileOptions,
    PluginStorageDownloadDataOperation extends StorageDownloadDataOperation,
    PluginStorageDownloadDataOptions extends StorageDownloadDataOptions,
    PluginStorageDownloadFileOperation extends StorageDownloadFileOperation,
    PluginStorageDownloadFileOptions extends StorageDownloadFileOptions,
    PluginStorageCopyOperation extends StorageCopyOperation,
    PluginStorageCopyOptions extends StorageCopyOptions,
    PluginStorageMoveOperation extends StorageMoveOperation,
    PluginStorageMoveOptions extends StorageMoveOptions,
    PluginStorageRemoveOperation extends StorageRemoveOperation,
    PluginStorageRemoveOptions extends StorageRemoveOptions,
    PluginStorageRemoveManyOperation extends StorageRemoveManyOperation,
    PluginStorageRemoveManyOptions extends StorageRemoveManyOptions,
    PluginStorageItem extends StorageItem,
    PluginTransferProgress extends StorageTransferProgress,
    Plugin extends StoragePluginInterface<
        PluginStorageListOperation,
        PluginStorageListOptions,
        PluginStorageGetPropertiesOperation,
        PluginStorageGetPropertiesOptions,
        PluginStorageGetUrlOperation,
        PluginStorageGetUrlOptions,
        PluginStorageUploadDataOperation,
        PluginStorageUploadDataOptions,
        PluginStorageUploadFileOperation,
        PluginStorageUploadFileOptions,
        PluginStorageDownloadDataOperation,
        PluginStorageDownloadDataOptions,
        PluginStorageDownloadFileOperation,
        PluginStorageDownloadFileOptions,
        PluginStorageCopyOperation,
        PluginStorageCopyOptions,
        PluginStorageMoveOperation,
        PluginStorageMoveOptions,
        PluginStorageRemoveOperation,
        PluginStorageRemoveOptions,
        PluginStorageRemoveManyOperation,
        PluginStorageRemoveManyOptions,
        PluginStorageItem,
        PluginTransferProgress>> extends AmplifyCategory<Plugin> {
  StorageCategory([Plugin? plugin]) : _pluginOverride = plugin;

  final Plugin? _pluginOverride;
  Plugin get _plugin => _pluginOverride ?? defaultPlugin;

  @override
  @nonVirtual
  Category get category => Category.storage;

  StorageCategory<
      GetPluginStorageListOperation,
      GetPluginStorageListOptions,
      GetPluginStorageGetPropertiesOperation,
      GetPluginStorageGetPropertiesOptions,
      GetPluginStorageGetUrlOperation,
      GetPluginStorageGetUrlOptions,
      GetPluginStorageUploadDataOperation,
      GetPluginStorageUploadDataOptions,
      GetPluginStorageUploadFileOperation,
      GetPluginStorageUploadFileOptions,
      GetPluginStorageDownloadDataOperation,
      GetPluginStorageDownloadDataOptions,
      GetPluginStorageDownloadFileOperation,
      GetPluginStorageDownloadFileOptions,
      GetPluginStorageCopyOperation,
      GetPluginStorageCopyOptions,
      GetPluginStorageMoveOperation,
      GetPluginStorageMoveOptions,
      GetPluginStorageRemoveOperation,
      GetPluginStorageRemoveOptions,
      GetPluginStorageRemoveManyOperation,
      GetPluginStorageRemoveManyOptions,
      GetPluginStorageItem,
      GetPluginTransferProgress,
      P> getPlugin<
          GetPluginStorageListOperation extends StorageListOperation,
          GetPluginStorageListOptions extends StorageListOptions,
          GetPluginStorageGetPropertiesOperation extends StorageGetPropertiesOperation,
          GetPluginStorageGetPropertiesOptions extends StorageGetPropertiesOptions,
          GetPluginStorageGetUrlOperation extends StorageGetUrlOperation,
          GetPluginStorageGetUrlOptions extends StorageGetUrlOptions,
          GetPluginStorageUploadDataOperation extends StorageUploadDataOperation,
          GetPluginStorageUploadDataOptions extends StorageUploadDataOptions,
          GetPluginStorageUploadFileOperation extends StorageUploadFileOperation,
          GetPluginStorageUploadFileOptions extends StorageUploadFileOptions,
          GetPluginStorageDownloadDataOperation extends StorageDownloadDataOperation,
          GetPluginStorageDownloadDataOptions extends StorageDownloadDataOptions,
          GetPluginStorageDownloadFileOperation extends StorageDownloadFileOperation,
          GetPluginStorageDownloadFileOptions extends StorageDownloadFileOptions,
          GetPluginStorageCopyOperation extends StorageCopyOperation,
          GetPluginStorageCopyOptions extends StorageCopyOptions,
          GetPluginStorageMoveOperation extends StorageMoveOperation,
          GetPluginStorageMoveOptions extends StorageMoveOptions,
          GetPluginStorageRemoveOperation extends StorageRemoveOperation,
          GetPluginStorageRemoveOptions extends StorageRemoveOptions,
          GetPluginStorageRemoveManyOperation extends StorageRemoveManyOperation,
          GetPluginStorageRemoveManyOptions extends StorageRemoveManyOptions,
          GetPluginStorageItem extends StorageItem,
          GetPluginTransferProgress extends StorageTransferProgress,
          P extends StoragePluginInterface<
              GetPluginStorageListOperation,
              GetPluginStorageListOptions,
              GetPluginStorageGetPropertiesOperation,
              GetPluginStorageGetPropertiesOptions,
              GetPluginStorageGetUrlOperation,
              GetPluginStorageGetUrlOptions,
              GetPluginStorageUploadDataOperation,
              GetPluginStorageUploadDataOptions,
              GetPluginStorageUploadFileOperation,
              GetPluginStorageUploadFileOptions,
              GetPluginStorageDownloadDataOperation,
              GetPluginStorageDownloadDataOptions,
              GetPluginStorageDownloadFileOperation,
              GetPluginStorageDownloadFileOptions,
              GetPluginStorageCopyOperation,
              GetPluginStorageCopyOptions,
              GetPluginStorageMoveOperation,
              GetPluginStorageMoveOptions,
              GetPluginStorageRemoveOperation,
              GetPluginStorageRemoveOptions,
              GetPluginStorageRemoveManyOperation,
              GetPluginStorageRemoveManyOptions,
              GetPluginStorageItem,
              GetPluginTransferProgress>>(
    StoragePluginKey<
            GetPluginStorageListOperation,
            GetPluginStorageListOptions,
            GetPluginStorageGetPropertiesOperation,
            GetPluginStorageGetPropertiesOptions,
            GetPluginStorageGetUrlOperation,
            GetPluginStorageGetUrlOptions,
            GetPluginStorageUploadDataOperation,
            GetPluginStorageUploadDataOptions,
            GetPluginStorageUploadFileOperation,
            GetPluginStorageUploadFileOptions,
            GetPluginStorageDownloadDataOperation,
            GetPluginStorageDownloadDataOptions,
            GetPluginStorageDownloadFileOperation,
            GetPluginStorageDownloadFileOptions,
            GetPluginStorageCopyOperation,
            GetPluginStorageCopyOptions,
            GetPluginStorageMoveOperation,
            GetPluginStorageMoveOptions,
            GetPluginStorageRemoveOperation,
            GetPluginStorageRemoveOptions,
            GetPluginStorageRemoveManyOperation,
            GetPluginStorageRemoveManyOptions,
            GetPluginStorageItem,
            GetPluginTransferProgress,
            P>
        pluginKey,
  ) =>
      StorageCategory(
        plugins.singleWhere(
          (p) => p is P,
          orElse: () => throw PluginError(
            'No plugin registered for $pluginKey',
          ),
        ) as P,
      );

  /// {@template amplify_core.amplify_storage_category.list}
  /// Lists objects under the [path] with optional [StorageListOptions] and
  /// returns a [StorageListOperation].
  /// {@endtemplate}
  PluginStorageListOperation list({
    String? path,
    PluginStorageListOptions? options,
  }) {
    return _plugin.list(
      path: path,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.get_properties}
  /// Retrieves properties of the object specified by [key] with optional
  /// [StorageGetPropertiesOptions]. And returns a
  /// [StorageGetPropertiesOperation].
  ///
  /// The result may include the metadata (if any) specified when the object
  /// was uploaded.
  /// {@endtemplate}
  PluginStorageGetPropertiesOperation getProperties({
    required String key,
    PluginStorageGetPropertiesOptions? options,
  }) {
    return _plugin.getProperties(
      key: key,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.get_url}
  /// Generates a downloadable url for the object specified by [key] with
  /// [StorageGetUrlOptions], and returns a [StorageGetUrlOperation].
  ///
  /// The url is presigned by the aws_signature_v4, and is enforced with scheme
  /// `https`.
  /// {@endtemplate}
  PluginStorageGetUrlOperation getUrl({
    required String key,
    PluginStorageGetUrlOptions? options,
  }) {
    return _plugin.getUrl(
      key: key,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.download_data}
  /// Downloads bytes of object specified by [key] into memory with optional
  /// [onProgress] and [StorageDownloadDataOptions], and returns a
  /// [StorageDownloadDataOperation].
  ///
  /// Ensure you are managing the data in memory properly to avoid unexpected
  /// memory leaks.
  /// {@endtemplate}
  PluginStorageDownloadDataOperation downloadData({
    required String key,
    void Function(PluginTransferProgress)? onProgress,
    PluginStorageDownloadDataOptions? options,
  }) {
    return _plugin.downloadData(
      key: key,
      onProgress: onProgress,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.download_file}
  /// Downloads the object specified by [key] to [localFile] with optional
  /// [onProgress] and [StorageDownloadFileOptions], and returns a
  /// [StorageDownloadFileOperation].
  /// {@endtemplate}
  PluginStorageDownloadFileOperation downloadFile({
    required String key,
    required AWSFile localFile,
    void Function(PluginTransferProgress)? onProgress,
    PluginStorageDownloadFileOptions? options,
  }) {
    return _plugin.downloadFile(
      key: key,
      localFile: localFile,
      onProgress: onProgress,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.upload_data}
  /// Uploads [data] as a [StorageDataPayload] with optional
  /// [onProgress] and [StorageUploadDataOptions] to object specified by [key],
  /// and returns a [StorageUploadDataOperation].
  ///
  /// See [StorageDataPayload] for supported data formats.
  /// {@endtemplate}
  PluginStorageUploadDataOperation uploadData({
    required StorageDataPayload data,
    required String key,
    void Function(PluginTransferProgress)? onProgress,
    PluginStorageUploadDataOptions? options,
  }) {
    return _plugin.uploadData(
      key: key,
      data: data,
      onProgress: onProgress,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.upload_file}
  /// Uploads data from [localFile] with optional [onProgress] and
  /// [StorageUploadFileOptions] to object specified by [key], and returns a
  /// [StorageUploadFileOperation].
  ///
  /// [AWSFile] provides various adapters to read file content from file
  /// abstractions, such as `XFile`, `PlatformFile`, `io.File` or `html.File`.
  /// {@endtemplate}
  PluginStorageUploadFileOperation uploadFile({
    required AWSFile localFile,
    required String key,
    void Function(PluginTransferProgress)? onProgress,
    PluginStorageUploadFileOptions? options,
  }) {
    return _plugin.uploadFile(
      key: key,
      localFile: localFile,
      onProgress: onProgress,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.copy}
  /// Makes a copy of the [source] to [destination] with optional
  /// [StorageCopyOptions], and returns a [StorageCopyOperation].
  /// {@endtemplate}
  ///
  /// {@template amplify_core.amplify_storage_category.copy_source}
  /// The `source` should be readable to the API call originator following
  /// corresponding [StorageAccessLevel].
  /// {@endtemplate}
  PluginStorageCopyOperation copy({
    required StorageItemWithAccessLevel<PluginStorageItem> source,
    required StorageItemWithAccessLevel<PluginStorageItem> destination,
    PluginStorageCopyOptions? options,
  }) {
    return _plugin.copy(
      source: source,
      destination: destination,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.move}
  /// Moves [source] to [destination] with optional [StorageMoveOptions],
  /// and returns a [StorageMoveOperation].
  ///
  /// This API performs two consecutive S3 service calls:
  ///   1. copy the source object to destination objection
  ///   2. delete the source object
  ///
  /// {@macro amplify_core.amplify_storage_category.copy_source}
  /// {@endtemplate}
  PluginStorageMoveOperation move({
    required StorageItemWithAccessLevel<PluginStorageItem> source,
    required StorageItemWithAccessLevel<PluginStorageItem> destination,
    PluginStorageMoveOptions? options,
  }) {
    return _plugin.move(
      source: source,
      destination: destination,
      options: options,
    );
  }

  /// {@template amplify_core.amplify_storage_category.remove}
  /// Removes an object specified by [key] with optional [StorageRemoveOptions],
  /// and returns a [StorageRemoveOperation].
  /// {@endtemplate}
  PluginStorageRemoveOperation remove({
    required String key,
    PluginStorageRemoveOptions? options,
  }) {
    return _plugin.remove(key: key, options: options);
  }

  /// {@template amplify_core.amplify_storage_category.remove_many}
  /// Removes multiple objects specified by [keys] with optional
  /// [StorageRemoveManyOptions], and returns a [StorageRemoveManyOperation].
  /// {@endtemplate}
  PluginStorageRemoveManyOperation removeMany({
    required List<String> keys,
    PluginStorageRemoveManyOptions? options,
  }) {
    return _plugin.removeMany(
      keys: keys,
      options: options,
    );
  }
}
