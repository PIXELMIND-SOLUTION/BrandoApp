
import 'package:brando_app/models/Ecommerce/product_model.dart';
import 'package:brando_app/provider/Ecommerce/order_provider.dart';
import 'package:brando_app/views/Ecommerce/all_hostel_screen.dart' hide ProductModel;
import 'package:brando_app/views/Ecommerce/delivery_location_sheet.dart';
import 'package:brando_app/views/Ecommerce/product_banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  String? selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Cart items with product and quantity
  final Map<String, Map<String, dynamic>> _cart = {};

  static const Color kGreen = Color(0xFF1D9E75);
  static const Color kGreenLight = Color(0xFFEAF3DE);
  static const Color kGreenDark = Color(0xFF0F6E56);
  static const Color kBg = Color(0xFFF5F6FA);
  static const Color kCard = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    await provider.fetchCategories();
    await provider.fetchProducts();
    
    // Auto-select first category
    if (provider.categories.isNotEmpty && selectedCategoryId == null) {
      setState(() {
        selectedCategoryId = provider.categories.first.id;
      });
    }
  }

List<ProductModel> get filteredProducts {
  final provider = Provider.of<OrderProvider>(context, listen: false);
  
  // Filter by category
  List<ProductModel> categoryFiltered = provider.products;
  if (selectedCategoryId != null) {
    categoryFiltered = provider.products
        .where((p) => p.categoryId?.id == selectedCategoryId)
        .toList();
  }
  
  // Filter by search
  if (searchQuery.isEmpty) {
    return categoryFiltered;
  }
  
  return categoryFiltered
      .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
}

// Change to this:
List<ProductModel> getFilteredProducts(OrderProvider provider) {
  // Filter by category
  List<ProductModel> categoryFiltered = provider.products;
  if (selectedCategoryId != null) {
    categoryFiltered = provider.products
        .where((p) => p.categoryId?.id == selectedCategoryId)
        .toList();
  }
  
  // Filter by search
  if (searchQuery.isEmpty) {
    return categoryFiltered;
  }
  
  return categoryFiltered
      .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
}

  int getCartQuantity(String productId) {
    return _cart[productId]?['quantity'] ?? 0;
  }

  void updateQuantity(ProductModel product, bool increment) {
    setState(() {
      if (increment) {
        final currentQty = _cart[product.id]?['quantity'] ?? 0;
        _cart[product.id] = {
          'product': product,
          'quantity': currentQty + 1,
        };
      } else {
        final currentQty = _cart[product.id]?['quantity'] ?? 0;
        if (currentQty > 1) {
          _cart[product.id] = {
            'product': product,
            'quantity': currentQty - 1,
          };
        } else {
          _cart.remove(product.id);
        }
      }
    });
  }

  void removeFromCart(String productId) {
    setState(() {
      _cart.remove(productId);
    });
  }

  int get totalItems => _cart.values.fold(0, (sum, item) => sum + (item['quantity'] as int));

  int get totalPrice => _cart.values.fold(0, (sum, item) {
    final product = item['product'] as ProductModel;
    final quantity = item['quantity'] as int;
    return sum + (product.price * quantity);
  });

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeliveryLocationModal() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add items to your cart first')),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeliveryLocationSheet(
        cart: _cart,
        totalPrice: totalPrice,
        onOrderPlaced: () {
          // Clear cart after order placed
          setState(() {
            _cart.clear();
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderHistoryScreen()));
          
        },
      ),
    );
  }

  void _showCartModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Cart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _cart.clear();
                          });
                          setModalState(() {});
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24, thickness: 0.5),
                // Cart items list
                Expanded(
                  child: _cart.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 64,
                                color: Color(0xFFD3D1C7),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Your cart is empty',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFB4B2A9),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _cart.length,
                          itemBuilder: (context, index) {
                            final item = _cart.values.elementAt(index);
                            final product = item['product'] as ProductModel;
                            final quantity = item['quantity'] as int;
                            return _buildCartItemCard(product, quantity, setModalState);
                          },
                        ),
                ),
                // Total and Checkout
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kCard,
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFEEEEEE),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2A),
                            ),
                          ),
                          Text(
                            '₹$totalPrice',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: kGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _cart.isEmpty
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  _showDeliveryLocationModal();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen,
                            disabledBackgroundColor: const Color(0xFFD3D1C7),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItemCard(ProductModel product, int quantity, StateSetter setModalState) {
    final itemTotal = product.price * quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: Color(0xFFD3D1C7),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888780),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kGreenDark,
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls and remove
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Remove button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        removeFromCart(product.id);
                      });
                      setModalState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Quantity controls
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: () {
                            setState(() {
                              updateQuantity(product, false);
                            });
                            setModalState(() {});
                          },
                          enabled: quantity > 0,
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '$quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2A),
                            ),
                          ),
                        ),
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () {
                            setState(() {
                              updateQuantity(product, true);
                            });
                            setModalState(() {});
                          },
                          enabled: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '₹$itemTotal',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  final provider = Provider.of<OrderProvider>(context);
  
  return Scaffold(
    backgroundColor: kBg,
    appBar: _buildAppBar(),
    body: provider.isLoading &&
        provider.categories.isEmpty
    ? const Center(
        child:
            CircularProgressIndicator(),
      )
    : CustomScrollView(
        slivers: [

          // Top spacing
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 15,
            ),
          ),

          // Banner
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                8.0,
              ),
              child:
                  const ProductBannerWidget(),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child:
                _buildCategories(
              provider,
            ),
          ),

          // Search
          SliverToBoxAdapter(
            child:
                _buildSearch(),
          ),

          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                16,
                14,
                16,
                6,
              ),
              child: Text(
                selectedCategoryId !=
                            null &&
                        provider
                            .categories
                            .isNotEmpty
                    ? provider
                        .categories
                        .firstWhere(
                          (c) =>
                              c.id ==
                              selectedCategoryId,
                          orElse:
                              () =>
                                  provider
                                      .categories
                                      .first,
                        )
                        .name
                    : 'Products',
                style:
                    const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight
                          .w600,
                  color: Color(
                    0xFF888780,
                  ),
                  letterSpacing:
                      0.8,
                ),
              ),
            ),
          ),

          // Product List
          _buildProductListSliver(
            provider,
          ),
        ],
      ),
    bottomNavigationBar: _buildBottomPanel(),
  );
}

Widget _buildProductListSliver(
    OrderProvider provider) {
  final list =
      getFilteredProducts(
          provider);

  if (provider.isLoading) {
    return const SliverFillRemaining(
      child: Center(
        child:
            CircularProgressIndicator(),
      ),
    );
  }

  if (list.isEmpty) {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .search_off_rounded,
              size: 48,
              color: Color(
                0xFFD3D1C7,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                color: Color(
                  0xFFB4B2A9,
                ),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  return SliverPadding(
    padding:
        const EdgeInsets.fromLTRB(
      16,
      0,
      16,
      12,
    ),
    sliver: SliverList(
      delegate:
          SliverChildBuilderDelegate(
        (_, i) =>
            _buildProductCard(
          list[i],
        ),
        childCount:
            list.length,
      ),
    ),
  );
}

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kCard,
      elevation: 0,
      centerTitle: true,
      leading: const BackButton(color: Colors.black),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/home.png', height: 50, width: 50),
          const SizedBox(width: 8),
          const Text(
            'Farm to Home',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 9, 202, 13),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderHistoryScreen(),
                  ),
                );
              },
              child: const Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
      ),
    );
  }

Widget _buildCategories(OrderProvider provider) {
  if (provider.categories.isEmpty) return const SizedBox();

  return SizedBox(
    height: 44,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      itemCount: provider.categories.length,
      itemBuilder: (_, i) {
        final category = provider.categories[i];
        final isSelected = selectedCategoryId == category.id;

        return GestureDetector(
          onTap: () => setState(
            () => selectedCategoryId = category.id,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? kGreen : kCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? kGreen
                    : const Color(0xFFE0E0E0),
                width: 0.5,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    category.image ?? '',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(
                          Icons.image,
                          size: 18,
                          color: Colors.grey,
                        ),
                  ),
                ),

                const SizedBox(width: 8),

                // Category Name
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF5F5E5A),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: const TextStyle(color: Color(0xFFB4B2A9), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFB4B2A9),
            size: 20,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFFB4B2A9),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: kCard,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kGreen, width: 1.5),
          ),
        ),
      ),
    );
  }

Widget _buildProductList(OrderProvider provider) {
  final list = getFilteredProducts(provider); // Changed this line
  if (provider.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (list.isEmpty) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Color(0xFFD3D1C7)),
          SizedBox(height: 12),
          Text(
            'No products found',
            style: TextStyle(color: Color(0xFFB4B2A9), fontSize: 14),
          ),
        ],
      ),
    );
  }
  return ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    itemCount: list.length,
    itemBuilder: (_, i) => _buildProductCard(list[i]),
  );
}

  // Widget _buildProductCard(ProductModel product) {
  //   final qty = getCartQuantity(product.id);
  //   final hasQty = qty > 0;

  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 200),
  //     margin: const EdgeInsets.only(bottom: 10),
  //     decoration: BoxDecoration(
  //       color: kCard,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: hasQty ? const Color(0xFF9FE1CB) : const Color(0xFFEEEEEE),
  //         width: hasQty ? 1.0 : 0.5,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.03),
  //           blurRadius: 6,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         // Image
  //         Container(
  //           width: 95,
  //           height: 95,
  //           decoration: BoxDecoration(
  //             color: hasQty ? kGreenLight : const Color(0xFFF5F6FA),
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(12),
  //               bottomLeft: Radius.circular(12),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(10),
  //             child: Image.network(
  //               product.image,
  //               fit: BoxFit.contain,
  //               errorBuilder: (_, __, ___) => const Icon(
  //                 Icons.image_not_supported_outlined,
  //                 color: Color(0xFFD3D1C7),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         // Info
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 product.name,
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                   color: Color(0xFF2C2C2A),
  //                 ),
  //               ),
  //               const SizedBox(height: 3),
  //               Text(
  //                 product.type,
  //                 style: const TextStyle(
  //                   fontSize: 12,
  //                   color: Color(0xFF888780),
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Text(
  //                 '₹${product.price}',
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                   color: kGreenDark,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(right: 10),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Container(
  //                 height: 48,
  //                 decoration: BoxDecoration(
  //                   border: Border.all(
  //                     color: const Color(0xFFE0E0E0),
  //                     width: 0.5,
  //                   ),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     _qtyButton(
  //                       icon: Icons.remove,
  //                       onTap: () => updateQuantity(product, false),
  //                       enabled: qty > 0,
  //                     ),
  //                     SizedBox(
  //                       width: 36,
  //                       child: Text(
  //                         '$qty',
  //                         textAlign: TextAlign.center,
  //                         style: const TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold,
  //                           color: Color(0xFF2C2C2A),
  //                         ),
  //                       ),
  //                     ),
  //                     _qtyButton(
  //                       icon: Icons.add,
  //                       onTap: () => updateQuantity(product, true),
  //                       enabled: true,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                 height: 42,
  //                 alignment: Alignment.center,
  //                 padding: const EdgeInsets.symmetric(horizontal: 35),
  //                 decoration: BoxDecoration(
  //                   border: Border.all(
  //                     color: const Color(0xFFE0E0E0),
  //                     width: 0.5,
  //                   ),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Text(
  //                   qty > 0 ? '₹${product.price * qty}' : '₹0',
  //                   style: TextStyle(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w600,
  //                     color: qty > 0 ? kGreen : const Color(0xFFB4B2A9),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }



  Widget _buildProductCard(ProductModel product) {
  final qty = getCartQuantity(product.id);
  final hasQty = qty > 0;
  
  // Define a fixed width for both containers
  const double containerWidth = 90.0; // Reduced from 100 to 90

  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: hasQty ? const Color(0xFF9FE1CB) : const Color(0xFFEEEEEE),
        width: hasQty ? 1.0 : 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // Image - slightly smaller
        Container(
          width: 80, // Reduced from 95
          height: 80, // Reduced from 95
          decoration: BoxDecoration(
            color: hasQty ? kGreenLight : const Color(0xFFF5F6FA),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8), // Reduced from 10
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported_outlined,
                color: Color(0xFFD3D1C7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10), // Reduced from 12
        // Info - Expanded will take remaining space
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 14, // Slightly reduced
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                product.type,
                style: const TextStyle(
                  fontSize: 11, // Slightly reduced
                  color: Color(0xFF888780),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '₹${product.price}',
                style: const TextStyle(
                  fontSize: 14, // Slightly reduced
                  fontWeight: FontWeight.w600,
                  color: kGreenDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8), // Reduced spacing
        // Right side column with both containers
        SizedBox(
          width: containerWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Quantity container
              Container(
                width: containerWidth,
                height: 44, // Slightly reduced from 48
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _qtyButton(
                      icon: Icons.remove,
                      onTap: () => updateQuantity(product, false),
                      enabled: qty > 0,
                    ),
                    SizedBox(
                      width: 30, // Reduced from 36
                      child: Text(
                        '$qty',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15, // Slightly reduced
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2A),
                        ),
                      ),
                    ),
                    _qtyButton(
                      icon: Icons.add,
                      onTap: () => updateQuantity(product, true),
                      enabled: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6), // Reduced from 8
              // Price container
              Container(
                width: containerWidth,
                height: 38, // Slightly reduced from 42
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  qty > 0 ? '₹${product.price * qty}' : '₹0',
                  style: TextStyle(
                    fontSize: 12, // Slightly reduced
                    fontWeight: FontWeight.w600,
                    color: qty > 0 ? kGreen : const Color(0xFFB4B2A9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8), // Add consistent spacing at the end
      ],
    ),
  );
}

// Update the qty button size as well
Widget _qtyButton({
  required IconData icon,
  required VoidCallback onTap,
  required bool enabled,
}) {
  return GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(
      width: 28, // Reduced from 32
      height: 28, // Reduced from 32
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Icon(
        icon,
        size: 14, // Reduced from 16
        color: enabled ? const Color(0xFF5F5E5A) : const Color(0xFFD3D1C7),
      ),
    ),
  );
}

  // Widget _qtyButton({
  //   required IconData icon,
  //   required VoidCallback onTap,
  //   required bool enabled,
  // }) {
  //   return GestureDetector(
  //     onTap: enabled ? onTap : null,
  //     child: Container(
  //       width: 32,
  //       height: 32,
  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
  //       child: Icon(
  //         icon,
  //         size: 16,
  //         color: enabled ? const Color(0xFF5F5E5A) : const Color(0xFFD3D1C7),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomPanel() {
    final hasItems = _cart.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: kCard,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basket header
              if(hasItems)
              Row(
                children: [
                  const Text(
                    'Your basket',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF888780),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: hasItems ? kGreenLight : const Color(0xFFF1EFE8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$totalItems item${totalItems != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: hasItems
                            ? const Color(0xFF3B6D11)
                            : const Color(0xFF888780),
                      ),
                    ),
                  ),
                ],
              ),
                            if(hasItems)

              const SizedBox(height: 8),

              // Cart chips or empty hint
                            if(hasItems)

                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cart.length,
                    itemBuilder: (_, i) {
                      final item = _cart.values.elementAt(i);
                      final product = item['product'] as ProductModel;
                      final quantity = item['quantity'] as int;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2C2C2A),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '×$quantity',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: kGreen,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if(hasItems)

              const SizedBox(height: 12),
                            if(hasItems)

              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Color(0xFFEEEEEE),
              ),
                            if(hasItems)

              const SizedBox(height: 12),
              if(hasItems)

              // Total + View Button + Pay Button
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB4B2A9),
                          ),
                        ),
                        Text(
                          '₹$totalPrice',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C2C2A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // View Button
                  if (hasItems)
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: OutlinedButton(
                        onPressed: _showCartModal,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kGreen,
                          side: const BorderSide(color: kGreen, width: 1.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: hasItems ? _showDeliveryLocationModal : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      disabledBackgroundColor: const Color(0xFFD3D1C7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Pay on Delivery',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}