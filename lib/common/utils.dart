import '../localization/loc_app.dart';
import 'package:intl/intl.dart';

/// Convert date into 7d, 6d, 5d, 4d, 3d, 2d, 1d, Today considering locale
String getDateText(DateTime date) {
  final DateTime now = DateTime.now();
  DateTime checkDate = DateTime(now.year, now.month, now.day - 7);
  String dateStr;
  if (date.isBefore(checkDate)) {
    dateStr = DateFormat.Md().format(date);
  } else if (date.isBefore(checkDate.add(const Duration(days: 1)))) {
    dateStr = LocApp.translate(LKeys.sevenD);
  } else if (date.isBefore(checkDate.add(const Duration(days: 2)))) {
    dateStr = LocApp.translate(LKeys.sixD);
  } else if (date.isBefore(checkDate.add(const Duration(days: 3)))) {
    dateStr = LocApp.translate(LKeys.fiveD);
  } else if (date.isBefore(checkDate.add(const Duration(days: 4)))) {
    dateStr = LocApp.translate(LKeys.fourD);
  } else if (date.isBefore(checkDate.add(const Duration(days: 5)))) {
    dateStr = LocApp.translate(LKeys.threeD);
  } else if (date.isBefore(checkDate.add(const Duration(days: 6)))) {
    dateStr = LocApp.translate(LKeys.twoD);
  } else if (date.isBefore(checkDate.add(const Duration(days: 7)))) {
    dateStr = LocApp.translate(LKeys.oneD);
  } else {
    dateStr = LocApp.translate(LKeys.today);
  }
  return dateStr;
}
