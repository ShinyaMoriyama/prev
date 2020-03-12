import 'dart:io';
import 'package:flutter/material.dart';
import 'package:last_time/screens/job_list_screen.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart';
import '../widgets/input_button.dart';

class InputScreen extends StatefulWidget {
  static const routeName = '/input';

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  Future<List<JobTypeItem>> _extractedJobType;

  @override
  void didChangeDependencies() {
    _extractedJobType =
        Provider.of<JobType>(context, listen: false).queryWhenInit();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final appBar = AppBar(
      title: Text('LastTime'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(JobListScreen.routeName);
            }),
      ],
    );
    final appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<List<JobTypeItem>>(
        future: _extractedJobType,
        builder: (ctx, dataSnapshot) {
          switch (dataSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: const CircularProgressIndicator(),
              );
            default:
              if (dataSnapshot.hasError) {
                return AlertDialog(
                  title: Text('Error occurred!'),
                  content: Text("Please try later."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () => exit(0),
                    ),
                  ],
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlueAccent.withOpacity(1.0),
                            Colors.lightBlue.withOpacity(0.4),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 1],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        height: deviceSize.height - appBarHeight,
                        width: deviceSize.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: dataSnapshot.data
                              .map((jobType) => InputButton(jobType))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
