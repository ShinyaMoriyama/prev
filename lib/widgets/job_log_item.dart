import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../localization/loc_app.dart';
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
        dateStr = LocApp.translate(LKeys.sevenD);
      } else if (date.isBefore(checkDate.add(const Duration(days: 2)))) {
        dateStr = LocApp.translate(LKeys.sixD);
      } else if (date.isBefore(checkDate.add(const Duration(days: 3)))) {
        dateStr = LocApp.translate(LKeys.fiveD);
      } else if (date.isBefore(checkDate.add(const Duration(days: 4)))) {
        dateStr = LocApp.translate(LKeys.fourD);
      } else if (date.isBefore(checkDate.add(const Duration(days: 5)))) {
        dateStr = LocApp.translate(LKeys.threeD);
      } else if (date.isBefore(checkDate.add(const Duration(days: 6)))) {
        dateStr = LocApp.translate(LKeys.twoD);
      } else if (date.isBefore(checkDate.add(const Duration(days: 7)))) {
        dateStr = LocApp.translate(LKeys.oneD);
      } else {
        dateStr = LocApp.translate(LKeys.today);
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
