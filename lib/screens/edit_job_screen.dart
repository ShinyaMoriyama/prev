import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_type.dart';
import '../models/color_select.dart';
import '../localization/app_localizations.dart';

class EditJobScreen extends StatefulWidget {
  const EditJobScreen({super.key});
  static const routeName = 'edit_job';

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _nameFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _isInit = true;

  var _initValues = {
    'name': '',
    'color': '',
  };

  late Future<JobTypeItem> _editedJobType;

  late JobTypeItem _editedJobTypeForSave;

  void _saveForm(BuildContext context, int jobTypeItemIndex) {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    Provider.of<JobType>(context, listen: false)
        .queryHas(jobTypeItemIndex)
        .then((existed) => existed
            ? Provider.of<JobType>(context, listen: false)
                .updateJobType(_editedJobTypeForSave)
                .then((_) {
                Navigator.of(context).pop();
              })
            : Provider.of<JobType>(context, listen: false)
                .addJobType(_editedJobTypeForSave)
                .then((_) {
                Navigator.of(context).pop();
              }));
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) return;

    final jobTypeItemType = ModalRoute.of(context)!.settings.arguments as int;

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

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final jobTypeItemType = ModalRoute.of(context)!.settings.arguments as int;

    return WillPopScope(
      onWillPop: showAlert,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.translate('Edit Job')),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _saveForm(context, jobTypeItemType),
            ),
          ],
        ),
        body: FutureBuilder<JobTypeItem>(
          future: _editedJobType,
          builder: (ctx, dataSnapshot) {
            switch (dataSnapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (dataSnapshot.hasError) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!
                        .translate('Error occurred.')),
                    content: Text(AppLocalizations.of(context)!
                        .translate("Please try later.")),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("OK"),
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
                              radius: 50,
                              backgroundColor: dataSnapshot.data!.color.object,
                              child: Text(
                                dataSnapshot.data!.color.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          TextFormField(
                            initialValue: _initValues['name'],
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .translate('Name')),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_nameFocusNode);
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('Please provide a name.');
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _editedJobTypeForSave = JobTypeItem(
                                    type: dataSnapshot.data!.type,
                                    name: value,
                                    color: dataSnapshot.data!.color);
                              }
                            },
                          ),
                          DropdownButtonFormField(
                            items: ColorSelect.values.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(AppLocalizations.of(context)!
                                    .translate(value.name)),
                              );
                            }).toList(),
                            value: dataSnapshot.data!.color,
                            onChanged: (ColorSelect? selectedValue) {
                              if (selectedValue != null) {
                                setState(() {
                                  dataSnapshot.data!.color = selectedValue;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .translate('Color')),
                            validator: (value) {
                              if (value == null) {
                                return AppLocalizations.of(context)!
                                    .translate('Please choose a color.');
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
              title: Text(AppLocalizations.of(context)!.translate('Back?')),
              content: Text(AppLocalizations.of(context)!
                  .translate('Unsaved data will be lost.')),
              actions: <Widget>[
                TextButton(
                  child: const Text("YES"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: const Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
