import 'package:brando_app/models/Ecommerce/product_model.dart';
import 'package:brando_app/provider/Ecommerce/order_provider.dart';
import 'package:brando_app/views/Ecommerce/manual_address_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class DeliveryLocationSheet extends StatefulWidget {
  final Map<String, Map<String, dynamic>> cart;
  final int totalPrice;
  final VoidCallback onOrderPlaced;

  const DeliveryLocationSheet({
    super.key,
    required this.cart,
    required this.totalPrice,
    required this.onOrderPlaced,
  });

  @override
  State<DeliveryLocationSheet> createState() => _DeliveryLocationSheetState();
}

class _DeliveryLocationSheetState extends State<DeliveryLocationSheet> {
  static const Color kGreen = Color(0xFF1D9E75);

  bool _isFetchingLocation = false;
  bool _isPlacingOrder = false;
  String? _fetchedLocation;

  // Convert cart to items array format expected by API
  List<Map<String, dynamic>> _getCartItems() {
    List<Map<String, dynamic>> items = [];
    for (var item in widget.cart.values) {
      final product = item['product'] as ProductModel;
      final quantity = item['quantity'] as int;
      items.add({
        'productId': product.id,
        'quantity': quantity,
      });
    }
    return items;
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isFetchingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() => _isFetchingLocation = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _isFetchingLocation = false;
        _fetchedLocation =
            'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}';
      });

      // Place order with live location
      await _placeOrderWithLiveLocation(position.latitude, position.longitude);
    } catch (e) {
      setState(() => _isFetchingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }

  Future<void> _placeOrderWithLiveLocation(double lat, double lng) async {
    setState(() => _isPlacingOrder = true);
    
    final provider = Provider.of<OrderProvider>(context, listen: false);
    
    // Get all cart items
    final items = _getCartItems();
    
    // Place single order with all products
    final result = await provider.placeOrderWithLiveLocation(
      items: items,
      latitude: lat,
      longitude: lng,
    );
    
    setState(() => _isPlacingOrder = false);
    
    if (result['success']) {
      // Close the delivery location sheet
      if (mounted) {
        Navigator.pop(context); // Close the sheet
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully! Waiting for admin approval.'),
            backgroundColor: kGreen,
          ),
        );
        
        // Call onOrderPlaced to clear cart
        widget.onOrderPlaced();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }

  void _showManualAddressModal() {
    // Don't pop immediately, just navigate to manual address
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ManualAddressSheet(
                cart: widget.cart,
                totalPrice: widget.totalPrice,
                onOrderPlaced: widget.onOrderPlaced,
              ),
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    ).then((_) {
      // When manual address sheet is closed, refresh if needed
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3DE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: kGreen,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Delivery Location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'How would you like to set your delivery address?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF888780),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),

          // Use Current Location button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (_isFetchingLocation || _isPlacingOrder) ? null : _fetchCurrentLocation,
              icon: _isFetchingLocation || _isPlacingOrder
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.my_location_rounded, size: 18),
              label: Text(
                _isFetchingLocation
                    ? 'Fetching location...'
                    : _isPlacingOrder
                        ? 'Placing order...'
                        : 'Use Current Location',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // OR divider
          Row(
            children: const [
              Expanded(
                child: Divider(thickness: 0.5, color: Color(0xFFE0E0E0)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB4B2A9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Divider(thickness: 0.5, color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Enter Manually button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: (_isFetchingLocation || _isPlacingOrder) ? null : _showManualAddressModal,
              icon: const Icon(Icons.edit_location_alt_rounded, size: 18),
              label: const Text(
                'Enter Address Manually',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: kGreen,
                side: const BorderSide(color: kGreen, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}