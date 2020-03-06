import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';

class EditJobScreen extends StatefulWidget {
  static const routeName = 'edit_job';

  @override
  _EditJobScreenState createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _nameFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _initValues = {
    'name': '',
    'color': '',
  };

  JobTypeItem _editedJobType;

  void _saveForm(BuildContext context, int jobTypeItemIndex) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (jobTypeItemIndex != null) {
      Provider.of<JobType>(context, listen: false)
          .updateJobType(_editedJobType.type, _editedJobType);
    } else {
      Provider.of<JobType>(context, listen: false).addJobType(_editedJobType);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final jobTypeItemType = ModalRoute.of(context).settings.arguments as int;
    if (jobTypeItemType != null) {
      _editedJobType = null;
      _editedJobType = Provider.of<JobType>(context, listen: false)
          .items
          .firstWhere((item) => item.type == jobTypeItemType);
      _initValues = {
        'name': _editedJobType.name,
        'color': _editedJobType.color.name,
      };
    } else {
      if (_editedJobType == null) {
        final _maxJobType = Provider.of<JobType>(context, listen: false)
            .items
            .map((e) => e.type)
            .reduce(max);
        _editedJobType =
            JobTypeItem(type: _maxJobType + 1, name: '', color: null);
        _initValues = {
          'name': '',
          'color': '',
        };
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Job'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(context, jobTypeItemType),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    _editedJobType.color == null
                        ? ''
                        : _editedJobType.color.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  radius: 50,
                  backgroundColor: _editedJobType.color == null
                      ? Colors.grey
                      : _editedJobType.color.object,
                ),
              ),
              TextFormField(
                initialValue: _initValues['name'],
                decoration: InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_nameFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedJobType = JobTypeItem(
                      type: _editedJobType.type,
                      name: value,
                      color: _editedJobType.color);
                },
              ),
              DropdownButtonFormField(
                items: ColorSelect.values.map((value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value.name),
                  );
                }).toList(),
                value: _editedJobType.color ?? _editedJobType.color,
                onChanged: (selectedValue) {
                  setState(() {
                    _editedJobType.color = selectedValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Color'),
                validator: (value) {
                  if (value == null) {
                    return 'Please choose a color.';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
