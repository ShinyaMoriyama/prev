import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../providers/job_log.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';

class JobLogItem extends StatelessWidget {
  final Job job;
  final JobTypeItem jobTypeItem;
  const JobLogItem(this.job, this.jobTypeItem, {super.key});

  @override
  Widget build(BuildContext context) {
    String getDateText(DateTime date) {
      final DateTime now = DateTime.now();
      DateTime checkDate = DateTime(now.year, now.month, now.day - 7);
      String dateStr;
      if (date.isBefore(checkDate)) {
        dateStr = DateFormat.Md().format(job.date);
      } else if (date.isBefore(checkDate.add(const Duration(days: 1)))) {
        dateStr = AppLocalizations.of(context)!.translate('7d');
      } else if (date.isBefore(checkDate.add(const Duration(days: 2)))) {
        dateStr = AppLocalizations.of(context)!.translate('6d');
      } else if (date.isBefore(checkDate.add(const Duration(days: 3)))) {
        dateStr = AppLocalizations.of(context)!.translate('5d');
      } else if (date.isBefore(checkDate.add(const Duration(days: 4)))) {
        dateStr = AppLocalizations.of(context)!.translate('4d');
      } else if (date.isBefore(checkDate.add(const Duration(days: 5)))) {
        dateStr = AppLocalizations.of(context)!.translate('3d');
      } else if (date.isBefore(checkDate.add(const Duration(days: 6)))) {
        dateStr = AppLocalizations.of(context)!.translate('2d');
      } else if (date.isBefore(checkDate.add(const Duration(days: 7)))) {
        dateStr = AppLocalizations.of(context)!.translate('1d');
      } else {
        dateStr = AppLocalizations.of(context)!.translate('Today');
      }
      return dateStr;
    }

    return ListTile(
      title: Text(
        DateFormat.yMd().add_Hm().format(job.date),
      ),
      leading: CircleAvatar(
        radius: 50,
        backgroundColor: jobTypeItem.color.object,
        child: Text(
          // DateFormat.Md().format(job.date),
          getDateText(job.date),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
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
