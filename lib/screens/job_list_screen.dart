import 'package:flutter/material.dart';
import 'package:last_time/screens/edit_job_screen.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart' as jt;
import '../widgets/job_type_item.dart';

class JobListScreen extends StatelessWidget {
  static const routeName = '/joblist';

  @override
  Widget build(BuildContext context) {
    var extractedJobType = Provider.of<jt.JobType>(context, listen: true).items;
    extractedJobType.sort((a, b) => a.type.compareTo(b.type));
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit your job'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditJobScreen.routeName);
            },
          )
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, i) => JobTypeItem(extractedJobType[i]),
        itemCount: extractedJobType.length,
        separatorBuilder: (context, _) => Divider(),
      ),
    );
  }
}
