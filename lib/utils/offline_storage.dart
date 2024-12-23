import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news.dart';

class OfflineStorage {
  static const key = 'offline_news';

  static Future<void> saveNews(News news) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(key);
    final List<dynamic> data = jsonData == null ? [] : jsonDecode(jsonData);

    if (!data.any((item) => item['id'] == news.id)) {
      data.add(news.toJson());
      await prefs.setString(key, jsonEncode(data));
    }
  }

  static Future<List<News>> loadNews() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(key);
    if (jsonData == null) return [];
    final List<dynamic> data = jsonDecode(jsonData);
    return data.map((json) => News.fromJson(json)).toList();
  }
}
