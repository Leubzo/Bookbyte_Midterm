import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookbytes_buyer/Models/books.dart';
import 'package:bookbytes_buyer/pages/book_detail.dart';
import 'package:bookbytes_buyer/Utilities/constants.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final ScrollController _scrollController = ScrollController();
  List<Book> books = [];
  List<Book> allBooks = [];
  int currentPage = 1;
  bool isLoading = false;
  late int totalPages = 1; // Placeholder for total pages

  @override
  void initState() {
    super.initState();
    fetchBooks();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchBooks();
      }
    });
  }

  Future<void> _pullToRefresh() async {
    currentPage = 1;
    allBooks.clear();
    await fetchBooks();
  }

  Future<void> fetchBooks({int? pageNumber}) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    currentPage = pageNumber ?? currentPage;
    var url = '${ApiConstants.baseUrl}/get_books.php?page=$currentPage';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success']) {
        setState(() {
          if (pageNumber != null) {
            books =
                List<Book>.from(jsonData['books'].map((x) => Book.fromJson(x)));
          } else {
            for (var x in jsonData['books']) {
              allBooks.add(Book.fromJson(x));
            }
            books = allBooks;
          }
          totalPages = (jsonData['totalBooks'] / 10).ceil();
          currentPage++;
          isLoading = false;
        });
      }
    } else {
      isLoading = false;
    }
  }

  Future<void> searchBooks(String query) async {
    var url = '${ApiConstants.baseUrl}/search_books.php?search=$query';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success']) {
        setState(() {
          books =
              List<Book>.from(jsonData['books'].map((x) => Book.fromJson(x)));
        });
      }
    }
  }

  void updateSearchQuery(String newQuery) {
    if (newQuery.isEmpty) {
      setState(() => books = allBooks);
    } else {
      List<Book> filteredBooks = allBooks.where((book) {
        return book.title.toLowerCase().contains(newQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(newQuery.toLowerCase());
      }).toList();

      if (filteredBooks.isNotEmpty) {
        setState(() => books = filteredBooks);
      } else {
        searchBooks(newQuery);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
            ),
            onChanged: updateSearchQuery,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullToRefresh,
        child: books.isEmpty
            ? const Center(child: Text('No books found.'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailPage(book: books[index]),
                              ),
                            )
                                .then((value) {
                              // Check if the returned value is true, then refresh the list
                              if (value == true) {
                                fetchBooks();
                              }
                            });
                          },
                          child: ListTile(
                            leading: Image.network(
                              books[index].imageUrl,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(books[index].title),
                            subtitle: Text(books[index].author),
                          ),
                        );
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalPages, (index) {
                        return TextButton(
                          onPressed: () => fetchBooks(pageNumber: index + 1),
                          child: Text('${index + 1}'),
                        );
                      }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
