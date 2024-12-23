class News {
  final int id;
  final String title;
  final String content;
  final String tag;
  final String date;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tag: json['tag'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tag': tag,
      'date': date,
    };
  }
}
