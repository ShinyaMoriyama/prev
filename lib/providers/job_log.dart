import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';

class Job {
  DateTime date;
  int type;

  Job({
    required this.date,
    required this.type,
  });
}

class JobLog with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> updateJob(Job item) async {
    final key = DatabaseHelper.columnType;
    Map<String, dynamic> row = {
      DatabaseHelper.columnType: item.type,
      DatabaseHelper.columnDate: item.date.toIso8601String(),
    };
    final rowsAffected =
        await dbHelper.update(DatabaseHelper.tableJobLog, key, row);
    debugPrint('updated $rowsAffected row(s)');
    notifyListeners();
  }

  Future<DateTime?> lasttime(int type) async {
    final joblogList = await queryWhere(type);
    if (joblogList.isEmpty) {
      return null;
    } else {
      return joblogList.first.date;
    }
  }

  Future<void> addJob(Job job) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnDate: job.date.toIso8601String(),
      DatabaseHelper.columnType: job.type,
    };
    final id = await dbHelper.insert(DatabaseHelper.tableJobLog, row);
    debugPrint('inserted row id: $id');
    notifyListeners();
  }

  Future<Job> queryWhereSingle(int jobType, DateTime date) async {
    final allRows = await _query();
    final rowsWhere =
        allRows.where((job) => job.type == jobType && job.date == date).first;
    return rowsWhere;
  }

  Future<List<Job>> queryWhere(int jobType) async {
    final allRows = await _query();
    final rowsWhere = allRows.where((job) => job.type == jobType).toList();
    rowsWhere.sort((a, b) => b.date.compareTo(a.date));
    return rowsWhere;
  }

  Future<List<Job>> _query() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tableJobLog);
    debugPrint('query all rows:');
    for (var row in allRows) {
      debugPrint(row.toString());
    }
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
    final rowsDeleted = await dbHelper.delete(
        DatabaseHelper.tableJobLog, key, date.toIso8601String());
    debugPrint('deleted $rowsDeleted row(s): row $rowsDeleted');
    notifyListeners();
  }

  Future<void> deleteJobWhereJobType(int type) async {
    final key = DatabaseHelper.columnType;
    final rowsDeleted =
        await dbHelper.delete(DatabaseHelper.tableJobLog, key, type);
    debugPrint('joblog deleted $rowsDeleted row(s): row $rowsDeleted');
    notifyListeners();
  }
}
