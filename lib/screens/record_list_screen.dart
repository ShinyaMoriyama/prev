import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/app_localizations.dart';
import '../providers/job_log.dart';
import '../providers/job_type.dart';
import '../widgets/job_log_item.dart';

class RecordListScreen extends StatelessWidget {
  const RecordListScreen({super.key});
  static const routeName = '/record_list';

  @override
  Widget build(BuildContext context) {
    final jobType = ModalRoute.of(context)!.settings.arguments as int;
    Future<JobTypeItem> jobTypeItem =
        Provider.of<JobType>(context, listen: false).queryWhere(jobType);
    // This gets called even when back button is pushed.
    // We can't move this to initState due to 'listen: true' though.
    Future<List<Job>> extractedJobLog =
        Provider.of<JobLog>(context, listen: true).queryWhere(jobType);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('Your records')),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([jobTypeItem, extractedJobLog]),
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
                  itemBuilder: (context, i) => JobLogItem(
                      dataSnapshot.data![1][i], dataSnapshot.data![0]),
                  itemCount: dataSnapshot.data![1].length,
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
