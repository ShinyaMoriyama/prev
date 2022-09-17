import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../screens/edit_job_screen.dart';
import '../providers/job_type.dart' as jt;
import '../widgets/job_type_item.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  static const routeName = '/joblist';

  @override
  Widget build(BuildContext context) {
    // This gets called even when back button is pushed.
    // We can't move this to initState due to 'listen: true' though.
    Future<List<jt.JobTypeItem>> extractedJobType =
        Provider.of<jt.JobType>(context, listen: true).query();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('Your jobs list')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditJobScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder<List<jt.JobTypeItem>>(
        future: extractedJobType,
        builder: (ctx, dataSnapshot) {
          switch (dataSnapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (dataSnapshot.hasError) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!
                      .translate('Error occurred.')),
                  content: Text(AppLocalizations.of(context)!
                      .translate('Please try later.')),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () => exit(0),
                    ),
                  ],
                );
              } else {
                return ListView.separated(
                  itemBuilder: (context, i) =>
                      JobTypeItem(jobType: dataSnapshot.data![i]),
                  itemCount: dataSnapshot.data!.length,
                  separatorBuilder: (context, _) => const Divider(),
                  padding: const EdgeInsets.only(top: 10),
                );
              }
          }
        },
      ),
    );
  }
}
