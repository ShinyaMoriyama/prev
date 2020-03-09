import 'dart:io';
import 'package:flutter/material.dart';
import 'package:last_time/screens/edit_job_screen.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart' as jt;
import '../widgets/job_type_item.dart';

class JobListScreen extends StatelessWidget {
  static const routeName = '/joblist';

  @override
  Widget build(BuildContext context) {
    // This gets called even when back button is pushed.
    // We can't move this to initState due to 'listen: true' though.
    Future<List<jt.JobTypeItem>> extractedJobType =
        Provider.of<jt.JobType>(context, listen: true).query();

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
      body: FutureBuilder(
        future: extractedJobType,
        builder: (ctx, dataSnapshot) {
          switch (dataSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: const CircularProgressIndicator(),
              );
            default:
              if (dataSnapshot.hasError) {
                return AlertDialog(
                  title: Text('Error occurred in record list!'),
                  content: Text("Please try later."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () => exit(0),
                    ),
                  ],
                );
              } else {
                return ListView.separated(
                  itemBuilder: (context, i) => JobTypeItem(dataSnapshot.data[i]),
                  itemCount: dataSnapshot.data.length,
                  separatorBuilder: (context, _) => Divider(),
                );
              }
          }
        },
      ),
    );
  }
}
