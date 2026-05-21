
import 'package:brando_app/models/Ecommerce/category_model.dart';

class ProductModel {
  final String id;
  final String name;
  final int price;
  final String type;
  final String image;
  final CategoryModel? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.image,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      type: json['type'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['categoryId'] != null
          ? CategoryModel.fromJson(json['categoryId'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}