import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/job_type.dart';
import '../screens/input_screen.dart';
import '../common/try_later.dart';
import '../localization/loc_base.dart';
import '../localization/loc_app.dart';

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  late bool _futureDone;
  late Future<void> _futureFunc;

  void setLocale(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    LocBase.language = locale.languageCode;
  }

  Future<void> insertJobType(BuildContext context) async {
    final firstJobName = LocApp.translate(LKeys.someJob);
    debugPrint('JobType: $firstJobName');
    await Provider.of<JobType>(context, listen: false).initInsert(firstJobName);
  }

  Future<void> initialProcess(BuildContext context) async {
    setLocale(context);
    await insertJobType(context);
    _futureDone = true;
  }

  @override
  void initState() {
    super.initState();
    _futureDone = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("_futureDone: $_futureDone context: $context");
    // initialProcess is here because context is not available in initState
    if (!_futureDone) _futureFunc = initialProcess(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _futureFunc,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              debugPrint("error: ${snapshot.error}");
              return const TryLater();
            } else {
              return const InputScreen();
            }
          }
        });
  }
}
