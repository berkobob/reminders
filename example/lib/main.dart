import 'package:flutter/material.dart';
import 'package:reminders/reminders.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final reminders = Reminders();
  late final bool hasAccess;

  @override
  void initState() {
    super.initState();
    // hasAccess = reminders.hasAccess();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: FutureBuilder(
                future: reminders.hasAccess(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Text('App has access: ${snapshot.data}');
                }),
          ),
          body: Row()),
    );
  }
}
