import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                Provider.of<JobLog>(context, listen: false).deleteJob(job.date);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
