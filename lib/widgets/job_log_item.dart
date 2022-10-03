import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../localization/loc_app.dart';
import '../common/utils.dart' as utils;
import '../providers/job_log.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';
import '../screens/edit_record_screen.dart';

class JobLogItem extends StatelessWidget {
  final Job job;
  final JobTypeItem jobTypeItem;
  const JobLogItem(this.job, this.jobTypeItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        DateFormat.yMd().add_Hm().format(job.date),
      ),
      leading: CircleAvatar(
        radius: 50,
        backgroundColor: jobTypeItem.color.object,
        child: Text(
          utils.getDateText(job.date),
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
                Navigator.of(context).pushNamed(EditRecordScreen.routeName,
                    arguments: Job(
                      type: job.type,
                      date: job.date,
                    ));
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
          title: Text(LocApp.translate(LKeys.areYouSureWantToDeleteIt)),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("YES"),
              onPressed: () {
                Provider.of<JobLog>(context, listen: false)
                    .deleteJob(job.date)
                    .then((_) {
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
