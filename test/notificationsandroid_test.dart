import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

class MockFlutterLocalNotificationsPlugin extends Mock
    with
        MockPlatformInterfaceMixin // ignore: prefer_mixin
    implements
        FlutterLocalNotificationsPlatform {}

Future<void> initialAndroidNotifications() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.android;

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final MockFlutterLocalNotificationsPlugin mock =
      MockFlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsPlatform.instance = mock;

  const MethodChannel channel =
      MethodChannel('dexterous.com/flutter/local_notifications');
  final List<MethodCall> log = <MethodCall>[];

  group("Initialize notification", () {
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
        log.add(methodCall);
        return true;
      });
    });

    tearDown(() {
      log.clear();
    });

    test('Android', () async {
      await initialAndroidNotifications();

      expect(log, <Matcher>[
        isMethodCall('initialize', arguments: <String, Object>{
          'defaultIcon': 'app_icon',
        })
      ]);
    });
  });
}
