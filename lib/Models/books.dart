class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final String price;
  final String condition;
  final int sellerId;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.condition,
    required this.sellerId,
    required this.imageUrl,
  });

factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      price: json['price'],
      condition: json['condition'],
      sellerId: json['seller_id'],
      imageUrl: json['image_url'],
    );
  }

}
