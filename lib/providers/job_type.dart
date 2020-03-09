import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import '../database/database_helper.dart';
import '../models/color_select.dart';

class JobTypeItem {
  int type;
  String name;
  ColorSelect color;

  JobTypeItem({
    @required this.type,
    @required this.name,
    @required this.color,
  });
}

class JobType with ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<JobTypeItem> _items = [
    JobTypeItem(type: 0, name: 'a job', color: ColorSelect.Blue)
  ];

  List<JobTypeItem> get items {
    return [..._items];
  }

  void addJobType(JobTypeItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateJobType(int type, JobTypeItem item) {
    final index = _items.indexWhere((_item) => _item.type == type);
    _items[index] = item;
    notifyListeners();
  }

  void deleteJobType(int type) {
    _items.removeWhere((items) => items.type == type);
    notifyListeners();
  }

  Future<List<JobTypeItem>> queryWhenInit() async {
    int counts = await _count();
    if (counts == 0) {
      await _insert(
          JobTypeItem(type: 0, name: 'some job', color: ColorSelect.Green));
    }
    final rowsWhere = await _query();
    rowsWhere.sort((a, b) => a.type.compareTo(b.type));
    return rowsWhere;
  }

  Future<List<JobTypeItem>> query() async {
    final rowsWhere = await _query();
    rowsWhere.sort((a, b) => a.type.compareTo(b.type));
    return rowsWhere;
  }
  
  Future<JobTypeItem> queryWhere(int jobType) async {
    final allRows = await _query();
    print('in queryWhere');
    return allRows.firstWhere((item) => item.type == jobType);
  }

  Future<int> _count() async {
    final counts = await dbHelper.queryRowCount(DatabaseHelper.tableJobType);
    print('rowCount: $counts');
    return counts;
  }

  Future<void> _insert(JobTypeItem item) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnType: item.type,
      DatabaseHelper.columnName: item.name,
      DatabaseHelper.columnColor: item.color.name,
    };
    final id = await dbHelper.insert(DatabaseHelper.tableJobType, row);
    print('inserted row id: $id');
  }

  Future<List<JobTypeItem>> _query() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.tableJobType);
    print('query all rows:');
    allRows.forEach((row) => print(row));
    return allRows
        .map((item) => JobTypeItem(
              type: item['type'],
              name: item['name'],
              color: EnumToString.fromString(
                ColorSelect.values,
                item['color'],
              ),
            ))
        .toList();
  }

  Future<void> _update(JobTypeItem item) async {
    final key = DatabaseHelper.columnType;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: item.name,
      DatabaseHelper.columnColor: item.color.name,
    };
    final rowsAffected =
        await dbHelper.update(DatabaseHelper.tableJobType, key, row);
    print('updated $rowsAffected row(s)');
  }

  Future<void> _delete(int type) async {
    final key = DatabaseHelper.columnType;
    final rowsDeleted =
        await dbHelper.delete(DatabaseHelper.tableJobType, key, type);
    print('deleted $rowsDeleted row(s): row $rowsDeleted');
  }
}
