import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductBannerWidget extends StatefulWidget {
  const ProductBannerWidget({super.key});

  @override
  State<ProductBannerWidget> createState() =>
      _ProductBannerWidgetState();
}

class _ProductBannerWidgetState
    extends State<ProductBannerWidget> {
  List<String> bannerImages = [];
  bool isLoading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://187.127.146.52:2003/api/admin/product-banner',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final banners =
            jsonData['productBanners'] as List;

        bannerImages = banners.map<String>((item) {
          String image = item['image'] ?? '';

          // Fix broken URL issue
          if (image.contains('http://187.127.146.52:2003/http')) {
            image =
                image.replaceFirst(
                  'http://187.127.146.52:2003/',
                  '',
                );
          }

          return image;
        }).toList();
      }
    } catch (e) {
      debugPrint('Banner API Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 160,
        margin:
            const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.shade200,
        ),
      );
    }

    if (bannerImages.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerImages.length,
          itemBuilder: (
            context,
            index,
            realIndex,
          ) {
            return Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(18),
                child: Image.network(
                  bannerImages[index],
                  fit: BoxFit.fill,
                  width: double.infinity,
                  errorBuilder:
                      (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 160,
            viewportFraction: 1,
            autoPlay:
                bannerImages.length > 1,
            enlargeCenterPage: false,
            autoPlayInterval:
                const Duration(seconds: 3),
            onPageChanged:
                (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        // Dots Indicator
        if (bannerImages.length > 1)
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: List.generate(
              bannerImages.length,
              (index) => AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 300,
                ),
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                width:
                    currentIndex == index
                        ? 18
                        : 7,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  color:
                      currentIndex == index
                          ? Colors.green
                          : Colors.grey.shade300,
                ),
              ),
            ),
          ),
      ],
    );
  }
}