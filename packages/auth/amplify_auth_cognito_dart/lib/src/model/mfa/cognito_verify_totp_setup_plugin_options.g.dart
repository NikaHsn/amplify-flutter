// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cognito_verify_totp_setup_plugin_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CognitoVerifyTotpSetupPluginOptions
    _$CognitoVerifyTotpSetupPluginOptionsFromJson(Map<String, dynamic> json) =>
        $checkedCreate(
          'CognitoVerifyTotpSetupPluginOptions',
          json,
          ($checkedConvert) {
            final val = CognitoVerifyTotpSetupPluginOptions(
              friendlyDeviceName:
                  $checkedConvert('friendlyDeviceName', (v) => v as String?),
            );
            return val;
          },
        );

Map<String, dynamic> _$CognitoVerifyTotpSetupPluginOptionsToJson(
    CognitoVerifyTotpSetupPluginOptions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('friendlyDeviceName', instance.friendlyDeviceName);
  return val;
}
