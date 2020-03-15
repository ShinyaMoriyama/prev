import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';
import '../localization/app_localizations.dart';

class EditJobScreen extends StatefulWidget {
  static const routeName = 'edit_job';

  @override
  _EditJobScreenState createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _nameFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _isInit = true;

  var _initValues = {
    'name': '',
    'color': '',
  };

  Future<JobTypeItem> _editedJobType;

  JobTypeItem _editedJobTypeForSave;

  Future<void> _saveForm(BuildContext context, int jobTypeItemIndex) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (jobTypeItemIndex != null) {
      Provider.of<JobType>(context, listen: false)
          .updateJobType(_editedJobTypeForSave)
          .then((_) {
        Navigator.of(context).pop();
      });
    } else {
      Provider.of<JobType>(context, listen: false)
          .addJobType(_editedJobTypeForSave)
          .then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) return;

    final jobTypeItemType = ModalRoute.of(context).settings.arguments as int;

    if (jobTypeItemType != null) {
      _editedJobType = null;
      _editedJobType = Provider.of<JobType>(context, listen: false)
          .queryWhere(jobTypeItemType)
          .then((value) {
        _initValues = {
          'name': value.name,
          'color': value.color.name,
        };
        _isInit = false;
        return value;
      });
    } else {
      if (_editedJobType == null) {
        _editedJobType = Provider.of<JobType>(context, listen: false)
            .queryMaxType()
            .then((value) {
          _initValues = {
            'name': '',
            'color': '',
          };
          _isInit = false;
          return JobTypeItem(type: value + 1, name: '', color: null);
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final jobTypeItemType = ModalRoute.of(context).settings.arguments as int;

    return WillPopScope(
      onWillPop: showAlert,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('Edit Job')),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveForm(context, jobTypeItemType),
            ),
          ],
        ),
        body: FutureBuilder<JobTypeItem>(
          future: _editedJobType,
          builder: (ctx, dataSnapshot) {
            switch (dataSnapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: const CircularProgressIndicator(),
                );
              default:
                if (dataSnapshot.hasError) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).translate('Error occurred.')),
                    content: Text(AppLocalizations.of(context).translate("Please try later.")),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () => exit(0),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                dataSnapshot.data.color == null
                                    ? ''
                                    : dataSnapshot.data.color.name,
                                style: TextStyle(color: Colors.white),
                              ),
                              radius: 50,
                              backgroundColor: dataSnapshot.data.color == null
                                  ? Colors.grey
                                  : dataSnapshot.data.color.object,
                            ),
                          ),
                          TextFormField(
                            initialValue: _initValues['name'],
                            decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('Name')),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_nameFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppLocalizations.of(context).translate('Please provide a name.');
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedJobTypeForSave = JobTypeItem(
                                  type: dataSnapshot.data.type,
                                  name: value,
                                  color: dataSnapshot.data.color);
                            },
                          ),
                          DropdownButtonFormField(
                            items: ColorSelect.values.map((value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value.name),
                              );
                            }).toList(),
                            value: dataSnapshot.data.color ??
                                dataSnapshot.data.color,
                            onChanged: (selectedValue) {
                              setState(() {
                                dataSnapshot.data.color = selectedValue;
                              });
                            },
                            decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('Color')),
                            validator: (value) {
                              if (value == null) {
                                return AppLocalizations.of(context).translate('Please choose a color.');
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Future<bool> showAlert() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('Back?')),
          content: Text(AppLocalizations.of(context).translate('Unsaved data will be lost.')),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }
}
