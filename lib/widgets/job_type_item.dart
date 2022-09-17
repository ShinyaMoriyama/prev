import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/job_type.dart' as jt;
import '../providers/job_log.dart';
import '../screens/edit_job_screen.dart';
import '../models/color_select.dart';
import '../localization/app_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class JobTypeItem extends StatelessWidget {
  const JobTypeItem({required this.jobType, super.key});

  final jt.JobTypeItem jobType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(jobType.name),
      leading: CircleAvatar(
        radius: 50,
        backgroundColor: jobType.color.object,
        child: Text(
          jobType.color.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditJobScreen.routeName,
                    arguments: jobType.type);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showAlert(context);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .translate('Are You Sure Want To Delete It?')),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("YES"),
              onPressed: () {
                Provider.of<jt.JobType>(context, listen: false)
                    .deleteJobType(jobType.type)
                    .then((_) {
                  Provider.of<JobLog>(context, listen: false)
                      .deleteJobWhereJobType(jobType.type);
                }).then((_) {
                  Navigator.of(context).pop();
                  flutterLocalNotificationsPlugin.cancel(jobType.type);
                });
              },
            ),
            ElevatedButton(
              child: const Text("BACK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
