import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';

class Job {
  int jobId;
  DateTime date;
  int type;

  Job({
    required this.jobId,
    required this.date,
    required this.type,
  });
}

class JobLog with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> updateJob(Job item) async {
    final key = DatabaseHelper.columnJobId;
    Map<String, dynamic> row = {
      DatabaseHelper.columnJobId: item.jobId,
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

  Future<void> addJob({required DateTime date, required int type}) async {
    var allRows = await _query();
    Map<String, dynamic> row = {
      DatabaseHelper.columnJobId: allRows.length,
      DatabaseHelper.columnDate: date.toIso8601String(),
      DatabaseHelper.columnType: type,
    };
    final id = await dbHelper.insert(DatabaseHelper.tableJobLog, row);
    debugPrint('inserted row id: $id');
    notifyListeners();
  }

  Future<Job> queryWhereSingle(int jobId, int jobType, DateTime date) async {
    final allRows = await _query();
    final rowsWhere = allRows
        .where((job) =>
            job.jobId == jobId && job.type == jobType && job.date == date)
        .first;
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
            jobId: int.parse(item['jobId'].toString()),
            date: DateTime.parse(item['date']),
            type: int.parse(item['type'].toString()),
          ),
        )
        .toList();
  }

  Future<void> deleteJob(int jobId) async {
    final key = DatabaseHelper.columnJobId;
    final rowsDeleted = await dbHelper.delete(
      DatabaseHelper.tableJobLog,
      key,
      jobId,
    );
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
