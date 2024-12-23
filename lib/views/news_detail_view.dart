import 'package:flutter/material.dart';
import '../models/news.dart';

class NewsDetailsView extends StatelessWidget {
  final News news;
  const NewsDetailsView({
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(news.title, style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Тег: ${news.tag}',
                style: TextStyle(fontStyle: FontStyle.italic)),
            Text('Дата: ${news.date}'),
          ],
        ),
      ),
    );
  }
}
