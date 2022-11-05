class RemList {
  String title;
  String id;

  RemList(this.title, {this.id = ''});

  RemList.fromJson(json)
      : title = json['title'],
        id = json['id'];
}
