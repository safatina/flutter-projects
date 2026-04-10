import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/news_article.dart';
import 'package:newsapp/models/category.dart';
import 'package:newsapp/response_article.dart';

class ApiClient {
  static const String apiKey = '52f1a55524814ea2addbb2b92aa46cdc';
  static const String baseUrl = 'https://newsapi.org/v2';
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<List<NewsArticle>> fetchNews() async {
    try {
      final url = Uri.parse('$baseUrl/everything?q=indonesia&apiKey=$apiKey');
      
      print(' Memanggil API: $url');
      
      final response = await _httpClient.get(url);

      print(' Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseArticle = ResponseArticle.fromJson(data);
        
        print(' Berita ditemukan: ${responseArticle.articles.length} artikel');
        
        final List<NewsArticle> newsArticles = responseArticle.articles.map((apiArticle) {
          return NewsArticle(
            title: apiArticle.title,
            author: apiArticle.author,
            publishedDate: apiArticle.publishedAt,
            content: apiArticle.content,
            imageUrl: apiArticle.urlToImage.isNotEmpty ? apiArticle.urlToImage : null,
            category: _determineCategory(apiArticle.title, apiArticle.description),
          );
        }).toList();
        
        return newsArticles;
      } else {
        print(' API Error: ${response.statusCode}');
        print(' Response body: ${response.body}');
        
        return _getDummyArticles();
      }
    } catch (e) {
      print(' Network Error: $e');
      return _getDummyArticles();
    }
  }

  NewsCategory _determineCategory(String title, String description) {
    final text = (title + ' ' + description).toLowerCase();
    
    if (text.contains('tech') || text.contains('teknologi') || 
        text.contains('ai') || text.contains('digital') || 
        text.contains('gadget') || text.contains('aplikasi') ||
        text.contains('startup')) {
      return NewsCategory.technology;
    } else if (text.contains('science') || text.contains('sains') || 
               text.contains('penelitian') || text.contains('luar angkasa') ||
               text.contains('space') || text.contains('matahari') ||
               text.contains('ilmuan')) {
      return NewsCategory.science;
    } else if (text.contains('politik') || text.contains('politics') || 
               text.contains('pemerintah') || text.contains('government') ||
               text.contains('hukum') || text.contains('kriminal') ||
               text.contains('presiden') || text.contains('jokowi') ||
               text.contains('dpd') || text.contains('dpr') || 
               text.contains('kominfo')) {
      return NewsCategory.politics;
    } else if (text.contains('health') || text.contains('kesehatan') || 
               text.contains('obat') || text.contains('dokter') ||
               text.contains('rumah sakit') || text.contains('virus') ||
               text.contains('covid')) {
      return NewsCategory.health;
    } else if (text.contains('bisnis') || text.contains('business') || 
               text.contains('ekonomi') || text.contains('market') ||
               text.contains('saham') || text.contains('keuangan') ||
               text.contains('investasi') || text.contains('uang')) {
      return NewsCategory.business;
    }
    return NewsCategory.all;
  }

  List<NewsArticle> _getDummyArticles() {
    return [
      NewsArticle(
        title: 'Indonesia Continues Crackdown on Online Gambling Content',
        author: 'James Jones',
        publishedDate: DateTime(2024, 1, 3),
        content: 'Indonesia\'s Ministry of Communication and Informatics (Kominfo) has blocked access to over 800,000 forms of gambling-related online content. This crackdown is part of the government\'s ongoing efforts to protect citizens from harmful online activities.',
        imageUrl: null,
        category: NewsCategory.politics,
      ),
      NewsArticle(
        title: 'The Sun Just Spewed Material From Opposite Sides in Rare Phenomenon',
        author: 'Passant Rabie',
        publishedDate: DateTime(2024, 1, 24),
        content: 'In a rare astronomical event, the Sun has ejected material from opposite sides simultaneously. Scientists are studying this unusual phenomenon to better understand solar activity.',
        imageUrl: null,
        category: NewsCategory.science,
      ),
      NewsArticle(
        title: 'Perekonomian Indonesia Tumbuh 5% di Tahun 2024',
        author: 'BPS',
        publishedDate: DateTime(2024, 2, 1),
        content: 'Badan Pusat Statistik melaporkan pertumbuhan ekonomi Indonesia mencapai 5% pada tahun 2024, didorong oleh sektor digital dan ekspor.',
        imageUrl: null,
        category: NewsCategory.business,
      ),
      NewsArticle(
        title: 'Startup Teknologi Indonesia Mendominasi Asia Tenggara',
        author: 'Tech in Asia',
        publishedDate: DateTime(2024, 1, 30),
        content: 'Perusahaan rintisan teknologi asal Indonesia berhasil mendominasi pendanaan di kawasan Asia Tenggara sepanjang tahun 2024.',
        imageUrl: null,
        category: NewsCategory.technology,
      ),
    ];
  }

  void dispose() {
    _httpClient.close();
  }
}