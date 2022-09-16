import 'package:amplify_analytics_pinpoint_dart/src/impl/device_context_info_provider.dart';
import 'package:amplify_analytics_pinpoint_dart/src/sdk/pinpoint.dart';
import 'package:amplify_core/amplify_core.dart';

import 'package:built_collection/built_collection.dart';

import '../shared_prefs.dart';
import 'event_global_fields_manager.dart';

class EventCreator {
  static const int _maxEventTypeLength = 50;

  final EventGlobalFieldsManager _globalFieldsManager;
  final DeviceContextInfoProvider? _deviceContextInfoProvider;

  // TODO - consider failure to save event

  EventCreator._getInstance(
      this._globalFieldsManager, this._deviceContextInfoProvider);

  static Future<EventCreator> getInstance(SharedPrefs sharedPrefs,
          DeviceContextInfoProvider? deviceContextInfoProvider) async =>
      EventCreator._getInstance(
          await EventGlobalFieldsManager.getInstance(sharedPrefs),
          deviceContextInfoProvider);

  Event createPinpointEvent(String eventType, SessionBuilder? sessionBuilder,
      [AnalyticsEvent? analyticsEvent]) {
    if (eventType.length > _maxEventTypeLength) {
      throw const AnalyticsException(
          'The event type is too long, the max event type length is {$_maxEventTypeLength} characters.');
    }

    EventBuilder eventBuilder = EventBuilder();

    // Fill in defaults for all events
    eventBuilder.eventType = eventType;
    eventBuilder.sdkName = 'aws-sdk-dart';
    // TODO get from pubspec
    eventBuilder.clientSdkVersion = '0.1.0';

    eventBuilder.session = sessionBuilder;

    eventBuilder.timestamp = DateTime.now().toIso8601String();

    eventBuilder.appTitle = _deviceContextInfoProvider?.appName;
    eventBuilder.appPackageName = _deviceContextInfoProvider?.appPackageName;
    eventBuilder.appVersionCode = _deviceContextInfoProvider?.appVersion;

    var eventAttrs =
        Map<String, String>.from(_globalFieldsManager.globalAttributes);
    var eventMetrics =
        Map<String, double>.from(_globalFieldsManager.globalMetrics);

    if (analyticsEvent != null) {
      EventGlobalFieldsManager.extractAnalyticsProperties(
          eventAttrs, eventMetrics, analyticsEvent.properties);
    }

    eventBuilder.attributes = MapBuilder(eventAttrs);
    eventBuilder.metrics = MapBuilder(eventMetrics);

    return eventBuilder.build();
  }

  Future<void> registerGlobalProperties(
    AnalyticsProperties globalProperties,
  ) =>
      _globalFieldsManager.addGlobalProperties(globalProperties);

  Future<void> unregisterGlobalProperties(List<String> propertyNames) =>
      _globalFieldsManager.removeGlobalProperties(propertyNames);
}
