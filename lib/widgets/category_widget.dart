// widget/category_widget.dart
import 'package:brando_app/provider/category/category_provider.dart';
import 'package:brando_app/views/seeall/see_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final double imageSize;
  final Axis scrollDirection;
  final double spacing;

  const CategoryWidget({
    Key? key,
    this.imageSize = 55,
    this.scrollDirection = Axis.horizontal,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        if (categoryProvider.isLoading && categoryProvider.categories.isEmpty) {
          return SizedBox(
            height: imageSize + 25,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (categoryProvider.errorMessage != null) {
          return SizedBox(
            height: imageSize + 25,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade300,
                    size: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Failed to load categories',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        if (categoryProvider.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Categories List
            SizedBox(
              height: imageSize + 25,
              child: ListView.builder(
                scrollDirection: scrollDirection,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categoryProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryProvider.categories[index];
                  final hasImage =
                      category.image != null && category.image!.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeAllScreen(
                            selectedCategoryId: category.id,
                            selectedCategoryName: category.name,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: scrollDirection == Axis.horizontal
                          ? imageSize + 20
                          : null,
                      margin: EdgeInsets.symmetric(
                        horizontal: scrollDirection == Axis.horizontal ? 8 : 0,
                        vertical: scrollDirection == Axis.vertical ? 8 : 0,
                      ),
                      child: Column(
                        children: [
                          // Circular Image
                          Container(
                            width: imageSize,
                            height: imageSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: hasImage
                                  ? Image.network(
                                      category.image!,
                                      fit: BoxFit.cover,
                                      width: imageSize,
                                      height: imageSize,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.red,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                      errorBuilder: (context, error, stackTrace) {
                                        print(
                                          'Error loading image for ${category.name}: $error',
                                        );
                                        return _buildPlaceholder(
                                          category.name,
                                          imageSize,
                                        );
                                      },
                                    )
                                  : _buildPlaceholder(category.name, imageSize),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Category Name
                          SizedBox(
                            width: imageSize + 10,
                            child: Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaceholder(String name, double imageSize) {
    final color = _getCategoryColor(name);
    return Container(
      color: color.withOpacity(0.1),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: imageSize * 0.4,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  // Generate a consistent color based on category name
  Color _getCategoryColor(String name) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.brown,
      Colors.lime,
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}
