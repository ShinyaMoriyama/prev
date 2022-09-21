import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/try_later.dart';
import '../screens/job_list_screen.dart';
import '../providers/job_type.dart';
import '../widgets/input_button.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  static const routeName = '/input';

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
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
        title: const Text('Prev'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await Navigator.of(context).pushNamed(JobListScreen.routeName);
                setState(() {
                  _extractedJobType = futureJobType(context);
                });
              }),
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
                debugPrint("dataSnapshot.hasError");
                debugPrint(dataSnapshot.stackTrace.toString());

                return const TryLater();
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
                          stops: const [0, 1],
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
                            children: dataSnapshot.data!
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
