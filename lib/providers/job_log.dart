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

  void addJob(Job job) {
    _jobs.add(job);
    notifyListeners();
  }

  void deleteJob(DateTime date) {
    _jobs.removeWhere((job) => job.date == date);
    notifyListeners();
  }

  Future<List<Job>> queryWhere(int jobType) async{
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
            date: DateTime(item['date']),
            type: int.parse(item['type']),
          ),
        )
        .toList();
  }
}
