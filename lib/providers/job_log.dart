import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';

class Job {
  DateTime date;
  int type;

  Job({
    @required this.date,
    @required this.type,
  });
}

class JobLog with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<Job> _jobs = [];

  List<Job> get jobs {
    return [..._jobs];
  }

  Future<void> addJob(Job job) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnDate: job.date.toIso8601String(),
      DatabaseHelper.columnType: job.type,
    };
    final id = await dbHelper.insert(DatabaseHelper.tableJobLog, row);
    print('inserted row id: $id');
    notifyListeners();
  }

  Future<List<Job>> queryWhere(int jobType) async {
    final allRows = await _query();
    final rowsWhere = allRows.where((job) => job.type == jobType).toList();
    rowsWhere.sort((a, b) => b.date.compareTo(a.date));
    return rowsWhere;
  }

  Future<List<Job>> _query() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tableJobLog);
    print('query all rows:');
    allRows.forEach((row) => print(row));
    return allRows
        .map(
          (item) => Job(
            date: DateTime.parse(item['date']),
            type: int.parse(item['type'].toString()),
          ),
        )
        .toList();
  }

  Future<void> deleteJob(DateTime date) async {
    final key = DatabaseHelper.columnDate;
    final rowsDeleted =
        await dbHelper.delete(DatabaseHelper.tableJobLog, key, date.toIso8601String());
    print('deleted $rowsDeleted row(s): row $rowsDeleted');
    notifyListeners();
  }
}
