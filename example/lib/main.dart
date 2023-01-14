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
  RemList? currentList;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            FutureBuilder(
                future: reminders.hasAccess(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  final access = snapshot.data ?? false;
                  return access
                      ? TextButton(
                          onPressed: () => setState(() {
                            currentList = null;
                          }),
                          child: const Text(
                            'Get All',
                            style: TextStyle(
                                color: Colors.white, letterSpacing: 1.0),
                          ),
                        )
                      : const Icon(Icons.cancel_rounded, color: Colors.red);
                }),
          ],
          title: Text(currentList?.title ?? ''),
        ),
        drawer: Drawer(
          child: FutureBuilder(
              future: reminders.getAllLists(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<RemList>> snapshot) {
                final lists = snapshot.data ?? [];
                return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(lists[index].title),
                        onTap: () => setState(() {
                          currentList = lists[index];
                          Navigator.of(context).pop();
                        }),
                      );
                    },
                    itemCount: lists.length);
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final RemList list = currentList ??
                await reminders.getDefaultList() ??
                RemList('New List');
            final reminder =
                Reminder(list: list, title: 'Here is a new reminder');
            await reminders.saveReminder(reminder);
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        body: buildReminders(currentList?.id),
      ),
    );
  }

  Center buildReminders(String? list) {
    return Center(
      child: FutureBuilder(
          future: reminders.getReminders(currentList?.id),
          builder:
              (BuildContext context, AsyncSnapshot<List<Reminder>?> snapshot) {
            if (snapshot.hasData) {
              final List<Reminder> rems = snapshot.data ?? [];
              return ListView.builder(
                  itemCount: rems.length,
                  itemBuilder: (context, index) {
                    final reminder = rems[index];
                    return ListTile(
                      leading: Text('${reminder.priority}'),
                      title: Row(
                        children: [
                          Expanded(child: Text(reminder.title)),
                          GestureDetector(
                            child: Text(
                                reminder.dueDate?.toString() ?? 'No date set'),
                            onTap: () async {
                              reminder.dueDate = DateTime.now();
                              await reminders.saveReminder(reminder);
                              setState(() {});
                            },
                            onDoubleTap: () async {
                              reminder.dueDate = null;
                              await reminders.saveReminder(reminder);
                              setState(() {});
                            },
                          )
                        ],
                      ),
                      subtitle:
                          reminder.notes != null ? Text(reminder.notes!) : null,
                      trailing: GestureDetector(
                        child: reminder.isCompleted
                            ? const Icon(Icons.check_box)
                            : const Icon(Icons.check_box_outline_blank),
                        onTap: () async {
                          reminder.isCompleted = !reminder.isCompleted;
                          await reminders.saveReminder(reminder);
                          setState(() {});
                        },
                      ),
                      onLongPress: () async {
                        await reminders.deleteReminder(reminder.id!);
                        setState(() {});
                      },
                    );
                  });
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
