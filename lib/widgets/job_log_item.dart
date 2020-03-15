import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:last_time/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/job_log.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';

class JobLogItem extends StatelessWidget {
  final Job job;
  final JobTypeItem jobTypeItem;
  JobLogItem(this.job, this.jobTypeItem);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        DateFormat('dd/MM/yyyy hh:mm').format(job.date),
      ),
      leading: CircleAvatar(
        child: Text(
          DateFormat('dd/MM').format(job.date),
          style: TextStyle(color: Colors.white),
        ),
        radius: 50,
        backgroundColor: jobTypeItem.color.object,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
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
          title: Text(AppLocalizations.of(context).translate('Deletion')),
          content: Text(AppLocalizations.of(context).translate('Are You Sure Want To Delete It?')),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                Provider.of<JobLog>(context, listen: false)
                    .deleteJob(job.date)
                    .then((_) {
                  Navigator.of(context).pop();
                });
              },
            ),
            FlatButton(
              child: Text("BACK"),
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
