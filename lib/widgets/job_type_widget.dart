import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/job_type.dart';
import '../providers/job_log.dart';
import '../screens/edit_job_screen.dart';
import '../models/color_select.dart';
import '../localization/loc_app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class JobTypeWidget extends StatelessWidget {
  final JobTypeItem jobType;
  final void Function(BuildContext context) callBackSetState;
  const JobTypeWidget({
    required this.jobType,
    required this.callBackSetState,
    super.key,
  });

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
                Navigator.of(context)
                    .pushNamed(EditJobScreen.routeName, arguments: jobType.type)
                    .then((_) {
                  callBackSetState(context);
                });
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showAlert(context).then((_) {
                  callBackSetState(context);
                });
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocApp.translate(LKeys.areYouSureWantToDeleteIt)),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("YES"),
              onPressed: () {
                Provider.of<JobType>(context, listen: false)
                    .deleteJobType(jobType.type)
                    .then((_) {
                  Provider.of<JobLog>(context, listen: false)
                      .deleteJobWhereJobType(jobType.type);
                }).then((_) {
                  flutterLocalNotificationsPlugin.cancel(jobType.type);
                  Navigator.of(context).pop();
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
