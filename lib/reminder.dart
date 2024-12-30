import 'reminders_list.dart';

class Reminder {
  RemList list;
  String? id;
  String title;
  DateTime? dueDate;
  int priority;
  bool isCompleted;
  DateTime? completionDate;
  String? notes;

  Reminder(
      {required this.list,
      this.id,
      required this.title,
      this.dueDate,
      this.priority = 0,
      this.isCompleted = false,
      this.completionDate,
      this.notes});

  Reminder.fromJson(Map<String, dynamic> json)
      : list = RemList.fromJson(json['list']),
        id = json['id'],
        title = json['title'],
        priority = json['priority'],
        isCompleted = json['isCompleted'],
        completionDate = json['completionDate'] != null
            ? DateTime.parse(json['completionDate'])
            : null,
        notes = json['notes'] {
    if (json['dueDate'] != null) {
      final date = json['dueDate'];
      dueDate = DateTime(date['year']!, date['month']!, date['day']!,
          date['hour'] ?? 00, date['minute'] ?? 00, date['second'] ?? 00);
    }
  }

  Map<String, dynamic> toJson() => {
        'list': list.id,
        'id': id,
        'title': title,
        'dueDate': dueDate == null
            ? null
            : {
                'year': dueDate?.year,
                'month': dueDate?.month,
                'day': dueDate?.day,
                'hour': dueDate?.hour,
                'minute': dueDate?.minute,
                'second': dueDate?.second,
              },
        'priority': priority,
        'isCompleted': isCompleted,
        'completionDate': completionDate == null
            ? null
            : {
                'year': completionDate?.year,
                'month': completionDate?.month,
                'day': completionDate?.day,
                'hour': completionDate?.hour,
                'minute': completionDate?.minute,
                'second': completionDate?.second,
              },
        'notes': notes
      };

  @override
  String toString() =>
      '''List: ${list.title}\tTitle: $title\tdueDate: $dueDate\tPriority:
      $priority\tisComplete: $isCompleted \tCompletionDate:$completionDate\tNotes: $notes\tID: $id''';
}
