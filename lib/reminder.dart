class Reminder {
  String? id;
  String title;
  DateTime? dueDate;
  int priority;
  bool isCompleted;
  String? notes;

  Reminder(
      {this.id,
      required this.title,
      this.dueDate,
      this.priority = 0,
      this.isCompleted = false,
      this.notes});

  Reminder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        dueDate = json['dueDate'],
        priority = json['priority'],
        isCompleted = json['isCompleted'],
        notes = json['notes'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dueDate': dueDate,
        'priority': priority,
        'isCompleted': isCompleted,
        'notes': notes
      };

  @override
  String toString() =>
      'Title: $title\tdueDate: $dueDate\tPriority: $priority\tisComplete: $isCompleted\tNotes: $notes';
}
