import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/news_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = 'https://gumpvlozyeczfvqtwpkg.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd1bXB2bG96eWVjemZ2cXR3cGtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ3OTAzMjMsImV4cCI6MjA1MDM2NjMyM30.7u8OF0snIPq0Yaca7vYNfl8yUwUANfTS6ODWfHjHQ4w';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsListView(),
    );
  }
}
