import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<News>> fetchNews() async {
    try {
      final response = await supabase.from('news').select();

      if (response.isNotEmpty) {
        return response
            .map((json) => News.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Ошибка при загрузке данных');
      }
    } catch (error) {
      throw Exception('Ошибка: $error');
    }
  }
}
