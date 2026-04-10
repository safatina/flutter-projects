import 'package:newsapp/models/category.dart';

class NewsArticle {
  final String title;
  final String author;
  final DateTime publishedDate;
  final String content;
  final String? imageUrl;
  final NewsCategory category;

  NewsArticle({ 
    required this.title,
    required this.author,
    required this.publishedDate,
    required this.content,
    this.imageUrl,
    this.category = NewsCategory.all,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      author: json['author'] ?? 'Unknown',
      publishedDate: DateTime.tryParse(json['publishedDate'] ?? '') ?? DateTime.now(),
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      category: NewsCategory.fromString(json['category'] ?? 'all'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'publishedDate': publishedDate.toIso8601String(),
      'content': content,
      'imageUrl': imageUrl,
      'category': category.apiKey,
    };
  }
}