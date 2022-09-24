import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prev/main.dart' as app;

/// Testing regarding sqflite is done by integration tests because sqflite does not support unit and widget testing
/// Making the device notification permission YES does not required because it may not be related to the actual execution.
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
          return null;
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
        isMethodCall('initialize', arguments: <String, Object>{
          'requestAlertPermission': true,
          'requestSoundPermission': true,
          'requestBadgePermission': true,
          'defaultPresentAlert': true,
          'defaultPresentSound': true,
          'defaultPresentBadge': true,
        }),
        isMethodCall("periodicallyShow", arguments: <String, Object?>{
          'id': 0,
          'title': null,
          'body': "some job is done?",
          'calledAt': calledToday,
          'repeatInterval': RepeatInterval.daily.index,
          'platformSpecifics': <String, Object?>{
            "presentAlert": null,
            "presentSound": null,
            "presentBadge": null,
            "subtitle": null,
            "sound": null,
            "badgeNumber": null,
            "threadIdentifier": null,
            "attachments": null,
          },
          "payload": "",
        })
      ]);
    });
  });
}
