import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:newsapp/models/news_article.dart'; 
import 'package:newsapp/services/bookmark_service.dart';

class DetailNewsPage extends StatefulWidget {
  final NewsArticle article; 
  final VoidCallback? onBookmarkChanged;

  const DetailNewsPage({
    super.key,
    required this.article,
    this.onBookmarkChanged,
  });

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  late final BookmarkService _bookmarkService;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _bookmarkService = BookmarkService();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarked = await _bookmarkService.isBookmarked(widget.article);
    setState(() => _isBookmarked = isBookmarked);
  }

  Future<void> _toggleBookmark() async {
    await _bookmarkService.toggleBookmark(widget.article);
    setState(() => _isBookmarked = !_isBookmarked);
    widget.onBookmarkChanged?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Berita disimpan' : 'Berita dihapus dari bookmark'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _shareNews() {
    Share.share(
      '${widget.article.title}\n\n'
      'Oleh: ${widget.article.author}\n'
      '${_formatDate(widget.article.publishedDate)}\n\n'
      '${widget.article.content.substring(0, widget.article.content.length > 200 ? 200 : widget.article.content.length)}...\n\n'
      'Bagikan dari Aplikasi Berita',
      subject: widget.article.title,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.amber : null,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareNews,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.article.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 16),
            Chip(
              label: Text(widget.article.category.label),
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 12),
            Text(
              widget.article.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'By ${widget.article.author} • ${_formatDate(widget.article.publishedDate)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            Text(
              widget.article.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}