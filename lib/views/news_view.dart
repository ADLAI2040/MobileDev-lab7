import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../utils/supabase_api.dart';
import '../utils/offline_storage.dart';
import '../models/news.dart';
import './news_detail_view.dart';

class NewsListView extends StatefulWidget {
  @override
  _NewsListViewState createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  final supabase = SupabaseService();
  List<News> newsList = [];
  List<News> displayedNews = [];
  bool isOffline = false;
  String selectedTag = '';
  DateTime? selectedDate;
  String sortOption = 'desc';

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadNews() async {
    if (await hasInternet()) {
      final news = await supabase.fetchNews();
      setState(() {
        isOffline = false;
        newsList = news;
        displayedNews = List.from(news);
      });
    } else {
      final offlineNews = await OfflineStorage.loadNews();
      setState(() {
        isOffline = true;
        newsList = offlineNews;
        displayedNews = List.from(offlineNews);
      });
    }
  }

  void onNewsTapped(News news) async {
    await OfflineStorage.saveNews(news);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsView(news: news),
      ),
    );
  }

  Future<void> showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Фильтры'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Тег'),
                    onChanged: (value) {
                      setState(() {
                        selectedTag = value;
                      });
                    },
                  ),
                  if (selectedTag.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Выбранный тег: $selectedTag',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        selectedDate != null
                            ? 'Выбрана: ${DateFormat.yMMMd().format(selectedDate!)}'
                            : 'Дата не выбрана',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: const Text('Выбрать'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    applyFilters();
                  },
                  child: const Text('Применить'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTag = '';
                      selectedDate = null;
                    });
                  },
                  child: const Text('Сбросить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void applyFilters() {
    setState(() {
      displayedNews = newsList.where((news) {
        final matchesTag =
            selectedTag.isEmpty || news.tag.contains(selectedTag);

        final matchesDate = selectedDate == null ||
            news.date == DateFormat('yyyy-MM-dd').format(selectedDate!);

        return matchesTag && matchesDate;
      }).toList();
    });
  }

  void sortNews() {
    setState(() {
      displayedNews = List.from(newsList);
      if (sortOption == 'desc') {
        displayedNews.sort((a, b) => b.date.compareTo(a.date));
      } else if (sortOption == 'asc') {
        displayedNews.sort((a, b) => a.date.compareTo(b.date));
      } else if (sortOption == 'today') {
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        displayedNews =
            displayedNews.where((news) => news.date == today).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(isOffline ? 'Новости (offline)' : 'Новости',
            style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.white,
            onSelected: (value) {
              setState(() {
                sortOption = value;
                sortNews();
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'desc',
                  child: Text('Новые'),
                ),
                const PopupMenuItem(
                  value: 'asc',
                  child: Text('Старые'),
                ),
                const PopupMenuItem(
                  value: 'today',
                  child: Text('Сегодняшние'),
                ),
              ];
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () async {
              await showFilterDialog();
            },
          ),
        ],
      ),
      body: displayedNews.isEmpty
          ? const Center(child: Text('Нет новостей'))
          : ListView.builder(
              itemCount: displayedNews.length,
              itemBuilder: (context, index) {
                final news = displayedNews[index];
                return ListTile(
                    title: Text(news.title),
                    subtitle: Text('${news.tag} - ${news.date}'),
                    onTap: () {
                      onNewsTapped(news);
                    });
              },
            ),
    );
  }
}
