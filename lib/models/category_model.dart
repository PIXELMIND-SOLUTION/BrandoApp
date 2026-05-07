// model/category_model.dart
class Category {
  final String id;
  final String name;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // Try multiple possible field names for image
    String? imageUrl;

    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imageUrl = json['image'];
    } else if (json['imageUrl'] != null &&
        json['imageUrl'].toString().isNotEmpty) {
      imageUrl = json['imageUrl'];
    } else if (json['categoryImage'] != null &&
        json['categoryImage'].toString().isNotEmpty) {
      imageUrl = json['categoryImage'];
    } else if (json['icon'] != null && json['icon'].toString().isNotEmpty) {
      imageUrl = json['icon'];
    }

    // If the image URL doesn't start with http, prepend the base URL
    if (imageUrl != null &&
        !imageUrl.startsWith('http') &&
        !imageUrl.startsWith('https')) {
      imageUrl = 'http://187.127.146.52:2003$imageUrl';
    }

    print('Category: ${json['name']}, Image URL: $imageUrl');

    return Category(
      id: json['_id'],
      name: json['name'],
      image: imageUrl,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
