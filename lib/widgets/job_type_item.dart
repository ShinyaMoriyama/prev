import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart' as jt;
import '../screens/edit_job_screen.dart';
import '../models/color_select.dart';

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
                Provider.of<jt.JobType>(context, listen: false)
                    .deleteJobType(jobType.type);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
