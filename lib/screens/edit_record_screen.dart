import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/job_log.dart';
import '../localization/loc_app.dart';
import '../common/try_later.dart';

class EditRecordScreen extends StatefulWidget {
  const EditRecordScreen({super.key});
  static const routeName = 'edit_record';

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  final _form = GlobalKey<FormState>();

  var _isInit = true;

  late Future<Job> _editedJob;

  void _saveForm(BuildContext context) {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    Future.value(_editedJob).then((value) {
      Provider.of<JobLog>(context, listen: false).updateJob(value).then((_) {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) return;

    final jobArg = ModalRoute.of(context)!.settings.arguments as Job;
    _editedJob = Provider.of<JobLog>(context, listen: false)
        .queryWhereSingle(jobArg.type, jobArg.date)
        .then((value) {
      _isInit = false;
      return value;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showAlert,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocApp.translate(LKeys.editJob)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _saveForm(context),
            ),
          ],
        ),
        body: FutureBuilder<Job>(
          future: _editedJob,
          builder: (ctx, dataSnapshot) {
            switch (dataSnapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (dataSnapshot.hasError) {
                  return const TryLater();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            initialValue: DateFormat.yMd()
                                .format(dataSnapshot.data!.date),
                            decoration: InputDecoration(
                                labelText: LocApp.translate(LKeys.date)),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedTime = await showDatePicker(
                                initialDate: DateTime(
                                  dataSnapshot.data!.date.year,
                                  dataSnapshot.data!.date.month,
                                  dataSnapshot.data!.date.day,
                                ),
                                firstDate: DateTime(2020, 1, 1),
                                lastDate: DateTime.now(),
                                context: context,
                              );

                              if (pickedTime != null) {
                                var jobDate = dataSnapshot.data!.date;
                                var jobType = dataSnapshot.data!.type;
                                setState(() {
                                  _editedJob = Future<Job>.value(Job(
                                    date: DateTime(
                                      pickedTime.year,
                                      pickedTime.month,
                                      pickedTime.day,
                                      jobDate.hour,
                                      jobDate.minute,
                                    ),
                                    type: jobType,
                                  ));
                                });
                              }
                            },
                          ),
                          TextFormField(
                            initialValue:
                                DateFormat.Hm().format(dataSnapshot.data!.date),
                            decoration: InputDecoration(
                                labelText: LocApp.translate(LKeys.time)),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay(
                                  hour: dataSnapshot.data!.date.hour,
                                  minute: dataSnapshot.data!.date.minute,
                                ),
                                context: context,
                              );

                              if (pickedTime != null) {
                                var jobDate = dataSnapshot.data!.date;
                                var jobType = dataSnapshot.data!.type;
                                setState(() {
                                  _editedJob = Future<Job>.value(Job(
                                    date: DateTime(
                                      jobDate.year,
                                      jobDate.month,
                                      jobDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    ),
                                    type: jobType,
                                  ));
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Future<bool> showAlert() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(LocApp.translate(LKeys.back)),
              content: Text(LocApp.translate(LKeys.unsavedDataLost)),
              actions: <Widget>[
                TextButton(
                  child: const Text("YES"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: const Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
