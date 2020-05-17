import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './providers/job_log.dart';
import './providers/job_type.dart';
import './screens/input_screen.dart';
import './screens/record_list_screen.dart';
import './screens/job_list_screen.dart';
import './screens/edit_job_screen.dart';
import './localization/app_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> initializeNotification() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() async {
  // Workaround to 'The getter 'languageCode' was called on null flutter for iOS"
  // https://github.com/flutter/flutter/issues/39032
  WidgetsFlutterBinding.ensureInitialized();
  while (window.locale == null) {
    await Future.delayed(const Duration(milliseconds: 1));
  }
  final locale = window.locale;
  Intl.systemLocale = locale.toString();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<JobLog>(create: (context) => JobLog()),
        ChangeNotifierProvider<JobType>(create: (context) => JobType()),
      ],
      child: MaterialApp(
        home: InputScreen(),
        routes: {
          RecordListScreen.routeName: (context) => RecordListScreen(),
          JobListScreen.routeName: (context) => JobListScreen(),
          EditJobScreen.routeName: (context) => EditJobScreen(),
        },
        // List all of the app's supported locales here
        supportedLocales: [
          Locale('en'),
          Locale('ja'),
        ],
        // These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
      ),
    );
  }
}
