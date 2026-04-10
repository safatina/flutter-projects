import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:newsapp/models/news_article.dart';

class BookmarkService {
  static const String _bookmarksKey = 'bookmarks';
  final SharedPreferences? _prefs;

  BookmarkService({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ?? await SharedPreferences.getInstance();

  Future<void> addBookmark(NewsArticle article) async { 
    final prefs = await _instance;
    final bookmarks = await getBookmarks();
    
    if (!bookmarks.any((a) => a.title == article.title)) {
      bookmarks.add(article);
      final jsonList = bookmarks.map((a) => jsonEncode(a.toJson())).toList();
      await prefs.setStringList(_bookmarksKey, jsonList);
    }
  }

  Future<void> removeBookmark(NewsArticle article) async {  
    final prefs = await _instance;
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((a) => a.title == article.title);
    final jsonList = bookmarks.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_bookmarksKey, jsonList);
  }

  Future<List<NewsArticle>> getBookmarks() async { 
    final prefs = await _instance;
    final jsonList = prefs.getStringList(_bookmarksKey) ?? [];
    return jsonList
        .map((json) => NewsArticle.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<bool> isBookmarked(NewsArticle article) async {  
    final bookmarks = await getBookmarks();
    return bookmarks.any((a) => a.title == article.title);
  }

  Future<void> toggleBookmark(NewsArticle article) async {  
    if (await isBookmarked(article)) {
      await removeBookmark(article);
    } else {
      await addBookmark(article);
    }
  }
}