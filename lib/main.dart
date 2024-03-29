import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './providers/job_log.dart';
import './providers/job_type.dart';
import './widgets/init_app.dart';
import './screens/record_list_screen.dart';
import './screens/job_list_screen.dart';
import './screens/edit_job_screen.dart';
import './screens/edit_record_screen.dart';
import './constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // device rotation
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  // local notification
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS,
    android: initializationSettingsAndroid,
  );
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<JobLog>(create: (context) => JobLog()),
        ChangeNotifierProvider<JobType>(create: (context) => JobType()),
      ],
      child: MaterialApp(
        home: const InitApp(),
        routes: {
          RecordListScreen.routeName: (context) => const RecordListScreen(),
          JobListScreen.routeName: (context) => const JobListScreen(),
          EditJobScreen.routeName: (context) => const EditJobScreen(),
          EditRecordScreen.routeName: (context) => const EditRecordScreen(),
        },
        debugShowCheckedModeBanner: false,
        supportedLocales: supportedLocale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
