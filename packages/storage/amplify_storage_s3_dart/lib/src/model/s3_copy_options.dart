// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import 'package:amplify_core/amplify_core.dart';

/// {@template storage.amplify_storage_s3.copy_options}
/// The configurable parameters invoking the Storage S3 plugin `copy` API.
/// {@endtemplate}
class S3CopyOptions extends StorageCopyOptions {
  /// {@macro storage.amplify_storage_s3.copy_options}
  const S3CopyOptions({
    this.getProperties = false,
  });

  /// Creates [S3CopyOptions] from [StorageCopyOptions].
  factory S3CopyOptions.from(StorageCopyOptions? options) {
    return options != null && options is S3CopyOptions
        ? options
        : const S3CopyOptions();
  }

  /// Whether to retrieve properties for the copied object using the
  /// `getProperties` API.
  final bool getProperties;
}
