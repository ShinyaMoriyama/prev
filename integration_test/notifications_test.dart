import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prev/main.dart' as app;

/// Testing regarding sqflite should be done by integration tests because sqflite does not support unit and widget testing
/// Notification permission is not required since method channe is mocked.
/// F.Y.I: to change the permission applesimutils like as following
/// applesimutils --byId "AC88F2C0-C988-4C61-99D1-E3B9947667FD" --bundle "com.apple.CoreSimulator.SimDeviceType.iPhone-8" -sp notifications=unset
/// https://github.com/johnpryan/integration_test_permissions
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('dexterous.com/flutter/local_notifications');
  final List<MethodCall> log = <MethodCall>[];

  String calledToday = "called today";

  group('end-to-end regarding notification', () {
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (methodCall) async {
          if (methodCall.method == "periodicallyShow") {
            methodCall.arguments["calledAt"] = calledToday;
          }
          log.add(methodCall);
          return true;
        },
      );
    });

    tearDown(() {
      log.clear();
    });
    testWidgets('add an job that generates notification', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Prev'), findsOneWidget);

      await tester.tap(find.text('some job'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('YES'));
      await tester.pumpAndSettle();

      expect(find.text('Your records'), findsOneWidget);

      var jobLists = tester.widgetList(find.byType(CircleAvatar));
      expect(jobLists.length, 1);

      expect(log, <Matcher>[
        isMethodCall('initialize',
            arguments: Platform.isAndroid
                ? <String, Object>{
                    'defaultIcon': 'app_icon',
                  }
                : <String, Object>{
                    'requestAlertPermission': true,
                    'requestSoundPermission': true,
                    'requestBadgePermission': true,
                    'defaultPresentAlert': true,
                    'defaultPresentSound': true,
                    'defaultPresentBadge': true,
                    "requestCriticalPermission": false,
                    "notificationCategories": [],
                  }),
        if (Platform.isAndroid)
          isMethodCall("requestPermission", arguments: null),
        isMethodCall("periodicallyShow", arguments: <String, Object?>{
          'id': 0,
          'title': null,
          'body': "some job is done?",
          'calledAt': calledToday,
          'repeatInterval': RepeatInterval.daily.index,
          'platformSpecifics': Platform.isAndroid
              ? <String, Object?>{
                  "icon": null,
                  "channelId": "channel_ID",
                  "channelName": "channel name",
                  "channelDescription": "channel description",
                  "channelShowBadge": true,
                  "channelAction": 0,
                  "importance": 5,
                  "priority": 1,
                  "playSound": true,
                  "enableVibration": true,
                  "vibrationPattern": null,
                  "groupKey": null,
                  "setAsGroupSummary": false,
                  "groupAlertBehavior": 0,
                  "autoCancel": true,
                  "ongoing": false,
                  "colorAlpha": null,
                  "colorRed": null,
                  "colorGreen": null,
                  "colorBlue": null,
                  "onlyAlertOnce": false,
                  "showWhen": true,
                  "when": null,
                  "usesChronometer": false,
                  "showProgress": true,
                  "maxProgress": 0,
                  "progress": 0,
                  "indeterminate": false,
                  "enableLights": false,
                  "ledColorAlpha": null,
                  "ledColorRed": null,
                  "ledColorGreen": null,
                  "ledColorBlue": null,
                  "ledOnMs": null,
                  "ledOffMs": null,
                  "ticker": null,
                  "visibility": null,
                  "timeoutAfter": null,
                  "category": null,
                  "fullScreenIntent": false,
                  "shortcutId": null,
                  "additionalFlags": null,
                  "subText": null,
                  "tag": null,
                  "colorized": false,
                  "number": null,
                  "audioAttributesUsage": 5,
                  "style": 0,
                  "styleInformation": {
                    "htmlFormatContent": false,
                    "htmlFormatTitle": false
                  },
                  "allowWhileIdle": false,
                }
              : <String, Object?>{
                  "presentAlert": null,
                  "presentSound": null,
                  "presentBadge": null,
                  "subtitle": null,
                  "sound": null,
                  "badgeNumber": null,
                  "threadIdentifier": null,
                  "attachments": null,
                  "interruptionLevel": null,
                  "categoryIdentifier": null,
                },
          "payload": "",
        })
      ]);
    });
  });
}
