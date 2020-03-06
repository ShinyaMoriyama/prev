import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/job_log.dart';
import './providers/job_type.dart';
import './screens/input_screen.dart';
import './screens/record_list_screen.dart';
import './screens/job_list_screen.dart';
import './screens/edit_job_screen.dart';

void main() => runApp(MyApp());

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
      ),
    );
  }
}
