// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import 'package:amplify_core/amplify_core.dart';

/// {@template storage.amplify_storage_s3.move_options}
/// The configurable parameters invoking the Storage S3 plugin `copy`
/// API.
/// {@endtemplate}
class S3MoveOptions extends StorageMoveOptions {
  /// {@macro storage.amplify_storage_s3.move_options}
  const S3MoveOptions({
    this.getProperties = false,
  });

  /// Creates [S3MoveOptions] from [StorageMoveOptions].
  factory S3MoveOptions.from(StorageMoveOptions? options) {
    return options != null && options is S3MoveOptions
        ? options
        : const S3MoveOptions();
  }

  /// Whether to retrieve properties for the moved object using the
  /// `getProperties` API.
  final bool getProperties;
}
