import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp/response_article.dart';

class Client {
  static Future<List<Article>> fetchArticles() async {
    const url =
        'https://newsapi.org/v2/everything?q=indonesia&apiKey=52f1a55524814ea2addbb2b92aa46cdc';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody["status"] != "ok") {
          throw Exception(responseBody["message"]);
        }

        return ResponseArticle.fromJson(responseBody).articles;
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Gagal mengambil data: $e");
    }
  }
}