class Calendar {
  String id;
  String title;

  Calendar({required this.id, required this.title});

  Calendar.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];

  @override
  String toString() => 'Calendar: $id - $title';
}
