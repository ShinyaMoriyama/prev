import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/record_list_screen.dart';
import '../providers/job_log.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';
import '../localization/app_localizations.dart';

class InputButton extends StatelessWidget {
  final JobTypeItem jobType;

  InputButton(this.jobType);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ButtonTheme(
        minWidth: 250,
        child: RaisedButton(
          onPressed: () {
            showAlert(context);
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(10),
          color: jobType.color.object,
          child: Text(jobType.name, style: TextStyle(fontSize: 25)),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${jobType.name}' + AppLocalizations.of(context).translate(' is done?')),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                Provider.of<JobLog>(context, listen: false)
                    .addJob(Job(
                  type: jobType.type,
                  date: DateTime.now(),
                ))
                    .then((_) {
                  Navigator.of(context).pushReplacementNamed(
                      RecordListScreen.routeName,
                      arguments: jobType.type);
                });
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('NO(Just Looking)')),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    RecordListScreen.routeName,
                    arguments: jobType.type);
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
