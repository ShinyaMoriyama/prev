import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../screens/record_list_screen.dart';
import '../providers/job_log.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';
import '../localization/loc_app.dart';
import '../common/utils.dart' as utils;
import '../common/try_later.dart';

class InputButton extends StatefulWidget {
  final JobTypeItem jobType;

  const InputButton(this.jobType, {super.key});

  @override
  State<InputButton> createState() => _InputButtonState();
}

class _InputButtonState extends State<InputButton> {
  late Future<DateTime?> _lasttime;
  @override
  Widget build(BuildContext context) {
    _lasttime = Provider.of<JobLog>(context, listen: true)
        .lasttime(widget.jobType.type);
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          showAlert(context);
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(250),
          padding: const EdgeInsets.all(10),
          backgroundColor: widget.jobType.color.object,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Column(
          children: [
            Text(
              widget.jobType.name,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            FutureBuilder<DateTime?>(
              future: _lasttime,
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
                      final extracted = dataSnapshot.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            extracted == null
                                ? "-"
                                : utils.getDateText(extracted),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleNotification(String message, int id) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_ID',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      playSound: true,
      showProgress: true,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().periodicallyShow(
      id,
      null,
      message,
      RepeatInterval.daily,
      platformChannelSpecifics,
    );
  }

  Future<void> showAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String message =
            "${widget.jobType.name}${LocApp.translate(LKeys.isDone)}";

        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("YES"),
              onPressed: () {
                Provider.of<JobLog>(context, listen: false)
                    .addJob(
                  type: widget.jobType.type,
                  date: DateTime.now(),
                )
                    .then((_) {
                  Navigator.of(context).pushReplacementNamed(
                      RecordListScreen.routeName,
                      arguments: widget.jobType.type);
                });
                _scheduleNotification(message, widget.jobType.type);
              },
            ),
            ElevatedButton(
              child: Text(LocApp.translate(LKeys.nOJustLooking)),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    RecordListScreen.routeName,
                    arguments: widget.jobType.type);
              },
            ),
            ElevatedButton(
              child: const Text("BACK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
