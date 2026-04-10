import 'dart:convert';

ResponseArticle responseArticleFromJson(String str) =>
    ResponseArticle.fromJson(json.decode(str));

String responseArticleToJson(ResponseArticle data) =>
    json.encode(data.toJson());

class ResponseArticle {
  final String status;
  final int totalResults;
  final List<Article> articles;

  ResponseArticle({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory ResponseArticle.fromJson(Map<String, dynamic> json) =>
      ResponseArticle(
        status: json["status"] ?? "",
        totalResults: json["totalResults"] ?? 0,
        articles: List<Article>.from(
          (json["articles"] ?? []).map((x) => Article.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"] ?? {}),
        author: json["author"] ?? "Tidak ada author",
        title: json["title"] ?? "Tidak ada title",
        description: json["description"] ?? "Tidak ada description",
        url: json["url"] ?? "",
        urlToImage: json["urlToImage"] ??
            "https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg",
        publishedAt: DateTime.tryParse(json["publishedAt"] ?? "") ??
            DateTime.now(),
        content: json["content"] ?? "Tidak ada content",
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };
}

class Source {
  final String? id;
  final String name;

  Source({
    required this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"] ?? "Unknown Source",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}