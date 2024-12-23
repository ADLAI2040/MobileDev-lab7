import 'package:flutter/material.dart';
import '../models/news.dart';

class NewsItem extends StatelessWidget {
  final News news;

  const NewsItem({required this.news});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(news.title),
      subtitle: Text('${news.tag} - ${news.date}'),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: news,
        );
      },
    );
  }
}
