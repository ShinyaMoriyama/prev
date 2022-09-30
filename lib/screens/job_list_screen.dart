import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/loc_app.dart';
import '../screens/edit_job_screen.dart';
import '../providers/job_type.dart';
import '../widgets/job_type_widget.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  static const routeName = '/joblist';

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late Future<List<JobTypeItem>> _extractedJobType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _extractedJobType = futureJobType(context);
  }

  Future<List<JobTypeItem>> futureJobType(BuildContext context) async =>
      _extractedJobType = Provider.of<JobType>(context, listen: false).query();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocApp.translate(LKeys.yourJobsList)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).pushNamed(EditJobScreen.routeName);
              setState(() {
                _extractedJobType = futureJobType(context);
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<JobTypeItem>>(
        future: _extractedJobType,
        builder: (ctx, dataSnapshot) {
          switch (dataSnapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (dataSnapshot.hasError) {
                return AlertDialog(
                  title: Text(LocApp.translate(LKeys.errorOccurred)),
                  content: Text(LocApp.translate(LKeys.pleaseTryLater)),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () => exit(0),
                    ),
                  ],
                );
              } else {
                return ListView.separated(
                  itemBuilder: (context, i) => JobTypeWidget(
                    jobType: dataSnapshot.data![i],
                    callBackSetState: (ctx) {
                      setState(() {
                        _extractedJobType = futureJobType(ctx);
                      });
                    },
                  ),
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
