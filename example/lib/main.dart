import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:reminders/reminders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RemList? _defaultList;
  String _hasAccess = 'Unknown';
  String _platformVersion = 'Unknown';
  final _remindersPlugin = Reminders();
  List<RemList> _lists = [];
  List<Reminder> _rems = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool hasAccess;
    RemList? defaultList;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _remindersPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    hasAccess = await _remindersPlugin.hasAccess();

    defaultList = await _remindersPlugin.getDefaultList();

    final lists = await _remindersPlugin.getAllLists();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _hasAccess = hasAccess.toString();
      _defaultList = defaultList;
      _lists = lists ?? [];
      // _rems
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          Center(
            child: Text('Running on: $_platformVersion\n'),
          ),
          Center(
            child: Text('Has Access: $_hasAccess\n'),
          ),
          Center(
            child: Text('Default List: ${_defaultList?.title ?? "Failed"}'),
          ),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Pick a list: "),
              ListofLists(
                  lists: _lists,
                  cb: (String id) async {
                    final rems = await Reminders().getRemindersInList(id);
                    setState(() {
                      _rems = rems ?? [];
                    });
                  }),
              OutlinedButton(
                onPressed: () async {
                  final reminder = await Reminders().createReminder(Reminder(
                      list: _defaultList!,
                      title: "test reminder 3",
                      priority: 4,
                      isCompleted: true,
                      dueDate: DateTime(2023),
                      notes: "Here is another note!"));
                  setState(() {
                    _rems.add(reminder);
                  });
                },
                child: const Text("Create Reminder"),
              )
            ]),
          ),
          Expanded(
            child: ListView(
                shrinkWrap: true,
                children: _rems
                    .map((rem) => ListTile(
                          leading: Text(rem.priority.toString()),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(rem.title),
                              Text(rem.dueDate?.toString() ?? "No due date")
                            ],
                          ),
                          subtitle: rem.notes != null ? Text(rem.notes!) : null,
                          trailing: rem.isCompleted
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ))
                    .toList()),
          )
        ]),
      ),
    );
  }
}

class ListofLists extends StatefulWidget {
  final List<RemList> lists;
  final Function cb;
  const ListofLists({super.key, required this.lists, required this.cb});

  @override
  State<ListofLists> createState() => _ListofListsState();
}

class _ListofListsState extends State<ListofLists> {
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: widget.lists
          .map<DropdownMenuItem<String>>((list) =>
              DropdownMenuItem<String>(value: list.id, child: Text(list.title)))
          .toList(),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value;
          widget.cb(value);
        });
      },
    );
  }
}
