import 'package:flutter/material.dart';
import 'package:book_app/book.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Book> displayedBooks = listBook;

  void filterBook(String category) {
    setState(() {
      if (category == "All") {
        displayedBooks = listBook;
      } else {
        displayedBooks = listBook
            .where((book) => book.categoryBook.contains(category))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    displayedBooks = listBook;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mari Belajar\nTingkatkan Skill',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Image.asset(
                    'images/banner.png',
                    width: 100,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Text Books
              const Text(
                'Books',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              // KATEGORI FILTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ElevatedButton(
                    onPressed: () => filterBook("All"),
                    child: const Text("All"),
                  ),

                  ElevatedButton(
                    onPressed: () => filterBook("Sysadmin"),
                    child: const Text("Sysadmin"),
                  ),

                  ElevatedButton(
                    onPressed: () => filterBook("Network"),
                    child: const Text("Network"),
                  ),

                ],
              ),

              const SizedBox(height: 15),

              // LIST BUKU
              ListView.builder(
                itemCount: displayedBooks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  final book = displayedBooks[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(book: book),
                        ),
                      );
                    },

                    child: Container(
                      width: double.infinity,
                      height: 90,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 10),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6.0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          Image.asset(
                            book.image,
                            width: 64,
                          ),

                          const SizedBox(width: 10),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                book.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                book.categoryBook,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}