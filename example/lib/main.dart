import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:reminders/reminders.dart';
import 'package:reminders/reminders_list.dart';

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
  String _rems = "Nothing yet";

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Pick a list: "),
                ListofLists(
                    lists: _lists,
                    cb: (String id) async {
                      final x = await Reminders().getRemindersInList(id);
                      setState(() {
                        _rems = x.toString();
                      });
                    }),
              ],
            ),
          ),
          Center(
            child: Text(_rems),
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
