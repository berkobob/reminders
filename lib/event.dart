class Event {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final bool isAllDay;
  final String? notes;

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        startDate = DateTime.fromMicrosecondsSinceEpoch(json['startDate']),
        endDate = DateTime.fromMillisecondsSinceEpoch(json['endDate']),
        location = json['location'],
        isAllDay = json['isAllDay'],
        notes = json['notes'];

  @override
  String toString() =>
      'Event: $title on $startDate to $endDate at $location. All day: $isAllDay. Notes: $notes';
}
