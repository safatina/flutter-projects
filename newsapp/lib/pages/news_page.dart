import 'package:flutter/material.dart';
import 'package:newsapp/models/news_article.dart';
import 'package:newsapp/models/category.dart';
import 'package:newsapp/services/api_client.dart';
import 'package:newsapp/services/bookmark_service.dart';
import 'package:newsapp/widgets/news_card.dart';
import 'package:newsapp/widgets/category_chip.dart';
import 'detail_news_page.dart';
import 'search_page.dart';
import 'bookmark_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ApiClient _apiClient = ApiClient();
  final BookmarkService _bookmarkService = BookmarkService();
  
  NewsCategory _selectedCategory = NewsCategory.all;
  List<NewsArticle> _allArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    final articles = await _apiClient.fetchNews();
    setState(() {
      _allArticles = articles;
      _isLoading = false;
    });
  }

  List<NewsArticle> get _filteredArticles {
    if (_selectedCategory == NewsCategory.all) {
      return _allArticles;
    }
    return _allArticles.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Terkini'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Search
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(allArticles: _allArticles),
                ),
              );
            },
          ),
          // Tombol Bookmark
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category Chips
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: NewsCategory.values.length,
                    itemBuilder: (context, index) {
                      final category = NewsCategory.values[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.label),
                          selected: _selectedCategory == category,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: _selectedCategory == category ? Colors.white : Colors.black87,
                          ),
                          showCheckmark: false,
                        ),
                      );
                    },
                  ),
                ),
                // News List
                Expanded(
                  child: _filteredArticles.isEmpty
                      ? const Center(child: Text('Tidak ada berita di kategori ini'))
                      : ListView.builder(
                          itemCount: _filteredArticles.length,
                          itemBuilder: (context, index) {
                            final article = _filteredArticles[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(article.title, maxLines: 2),
                                subtitle: Text(article.author),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailNewsPage(
                                        article: article,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }
}