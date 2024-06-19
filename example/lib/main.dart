import 'package:flutter/material.dart';
import 'package:reminders/calendar.dart';
import 'package:reminders/event.dart';
import 'package:reminders/events.dart';
import 'package:reminders/reminders.dart';

void main() => runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Apple Events Kit',
    home: ExampleApp()));

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
    //request permission to access Reminders
    reminders.requestPermission();

    // events.getDefaultCalendar().then(print);
    // events.getAllCalendars().then(print);
    // events.hasEventsAccess().then(print);
    // events.requestAccess().then(print);
    // events
    //     .getEvents('A84E394E-C85B-4961-B878-EACB9C247020')
    //     .then((events) => events!.forEach(print));

    return Scaffold(
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
                        child: const Text('Get All'),
                      )
                    : const Icon(Icons.cancel_rounded, color: Colors.red);
              }),
          TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EventsPage())),
              child: const Text(
                'Events',
              )),
        ],
        title: Text(currentList?.title ?? 'All Lists'),
      ),
      drawer: Drawer(
        child: FutureBuilder(
            future: reminders.getAllLists(),
            builder:
                (BuildContext context, AsyncSnapshot<List<RemList>> snapshot) {
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
                              final now = DateTime.now();
                              reminder.dueDate =
                                  DateTime(now.year, now.month, now.day);
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

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final apple = Events();
  bool hasAccess = false;
  List<Calendar> calendars = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    apple.hasEventsAccess().then((r) => setState(() {
          hasAccess = r;
          if (hasAccess) getCalendars();
        }));
  }

  getCalendars() {
    apple.getAllCalendars().then((r) => setState(() {
          calendars = r ?? [];
        }));
  }

  loadCalendar(String id) {
    apple.getEvents(id).then((r) => setState(() => events = r ?? []));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          !hasAccess
              ? TextButton(
                  onPressed: () async {
                    final result = await apple.requestAccess();
                    setState(() {
                      hasAccess = result == 'true';
                    });
                  },
                  child: const Text('Request Access'))
              : const Text('Access granted')
        ],
      ),
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: ListView(
                shrinkWrap: true,
                children: calendars
                    .map((c) => ListTile(
                          title: TextButton(
                            onPressed: () => loadCalendar(c.id),
                            child: Text(c.title),
                          ),
                        ))
                    .toList()),
          ),
          Flexible(
            flex: 1,
            child: ListView(
              shrinkWrap: true,
              children: (events
                  .map((e) => ListTile(
                        title: Text(e.title),
                        subtitle: Text(e.notes ?? ''),
                      ))
                  .toList()),
            ),
          )
        ],
      ),
    );
  }
}
