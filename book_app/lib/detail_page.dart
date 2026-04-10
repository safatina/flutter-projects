import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:book_app/book.dart';

class DetailPage extends StatelessWidget {
  final Book book;

  const DetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),
      body: ListView(
        children: [
        
          // Gambar
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(book.image),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Image.asset(
                  book.image,
                  width: 130,
                ),
              ),
            ),
          ),

          // Judul + Info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [

                Text(
                  book.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    bookInfo(book.rate.toString(), 'Rating'),
                    bookInfo(book.page.toString(), 'Pages'),
                    bookInfo(book.language, 'Language'),
                  ],
                ),

                const SizedBox(height: 20),

                // Description Title
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                // Description Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: bookDesc(book.description),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget bookDesc(String description) {
    return Text(
      description,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget bookInfo(String value, String info) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          info,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}