import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart' as jt;
import '../providers/job_log.dart';
import '../screens/edit_job_screen.dart';
import '../models/color_select.dart';
import '../localization/app_localizations.dart';

class JobTypeItem extends StatelessWidget {
  final jt.JobTypeItem jobType;
  JobTypeItem(this.jobType);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(jobType.name),
      leading: CircleAvatar(
        child: Text(
          jobType.color.name,
          style: TextStyle(color: Colors.white),
        ),
        radius: 50,
        backgroundColor: jobType.color.object,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditJobScreen.routeName,
                    arguments: jobType.type);
              },
              color: Theme.of(context).primaryColor,
            ),
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
                Provider.of<jt.JobType>(context, listen: false)
                    .deleteJobType(jobType.type).then((_) {
                      Provider.of<JobLog>(context, listen: false).deleteJobWhereJobType(jobType.type);
                    })
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
