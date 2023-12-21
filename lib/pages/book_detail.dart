import 'package:bookbytes_buyer/Models/books.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class BookDetailPage extends StatefulWidget {
  final Book book;

  BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkUserRegistration();
  }

  Future<void> _checkUserRegistration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userEmail = prefs.getString('userEmail');

    // Check if user is registered based on whether userEmail is present
    setState(() {
      isRegistered = userEmail != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(widget.book.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              widget.book.imageUrl,
              fit: BoxFit.cover,
              height: 300,
              // Placeholder in case of no image or error
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/no_image_placeholder.png',
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.book.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Author: ${widget.book.author}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Price: ${widget.book.price}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Condition: ${widget.book.condition}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.book.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: isRegistered
                  ? ElevatedButton(
                      onPressed: () {
                        // Handle Buy Book button press
                      },
                      child: Text('Buy Book'),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
