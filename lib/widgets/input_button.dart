import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../screens/record_list_screen.dart';
import '../providers/job_log.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';
import '../localization/loc_app.dart';

class InputButton extends StatelessWidget {
  final JobTypeItem jobType;

  const InputButton(this.jobType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          showAlert(context);
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(250),
          padding: const EdgeInsets.all(10),
          backgroundColor: jobType.color.object,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Text(
          jobType.name,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
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

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String message = "${jobType.name}${LocApp.translate(LKeys.isDone)}";

        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("YES"),
              onPressed: () {
                Provider.of<JobLog>(context, listen: false)
                    .addJob(Job(
                  type: jobType.type,
                  date: DateTime.now(),
                ))
                    .then((_) {
                  Navigator.of(context).pushReplacementNamed(
                      RecordListScreen.routeName,
                      arguments: jobType.type);
                });
                _scheduleNotification(message, jobType.type);
              },
            ),
            ElevatedButton(
              child: Text(LocApp.translate(LKeys.nOJustLooking)),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    RecordListScreen.routeName,
                    arguments: jobType.type);
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
