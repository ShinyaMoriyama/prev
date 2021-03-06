import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/job_list_screen.dart';
import '../providers/job_type.dart';
import '../widgets/input_button.dart';
import '../localization/app_localizations.dart';

class InputScreen extends StatefulWidget {
  static const routeName = '/input';

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  Future<List<JobTypeItem>> _extractedJobType;

  @override
  Widget build(BuildContext context) {
    print('AppLocalizations: ${AppLocalizations.of(context).locale}');
    final firstJobName = AppLocalizations.of(context).translate('some job');
    // We can't move this to re-build when back button is pushed.
    print('JobType: $firstJobName');
    _extractedJobType = Provider.of<JobType>(context, listen: true)
        .queryWhenInit(firstJobName);
    final appBar = AppBar(
      title: Text('Prev'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(JobListScreen.routeName);
            }),
      ],
    );

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
                  title: Text(AppLocalizations.of(context)
                      .translate('Error occurred.')),
                  content: Text(AppLocalizations.of(context)
                      .translate("Please try later.")),
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
                    LayoutBuilder(
                      builder: (BuildContext context,
                          BoxConstraints viewportConstraints) {
                        return SingleChildScrollView(
                            child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                            minWidth: viewportConstraints.maxWidth,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: dataSnapshot.data
                                .map((jobType) => InputButton(jobType))
                                .toList(),
                          ),
                        ));
                      },
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
