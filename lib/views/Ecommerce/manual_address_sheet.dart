
// import 'package:brando_app/models/Ecommerce/product_model.dart';
// import 'package:brando_app/provider/Ecommerce/order_provider.dart';
// import 'package:brando_app/views/Ecommerce/delivery_location_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ManualAddressSheet extends StatefulWidget {
//   final Map<String, Map<String, dynamic>> cart;
//   final int totalPrice;
//   final VoidCallback onOrderPlaced;

//   const ManualAddressSheet({
//     super.key,
//     required this.cart,
//     required this.totalPrice,
//     required this.onOrderPlaced,
//   });

//   @override
//   State<ManualAddressSheet> createState() => _ManualAddressSheetState();
// }

// class _ManualAddressSheetState extends State<ManualAddressSheet> {
//   static const Color kGreen = Color(0xFF1D9E75);

//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   final _flatCtrl = TextEditingController();
//   final _areaCtrl = TextEditingController();
//   final _cityCtrl = TextEditingController();
//   final _pincodeCtrl = TextEditingController();
  
//   bool _isPlacingOrder = false;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _flatCtrl.dispose();
//     _areaCtrl.dispose();
//     _cityCtrl.dispose();
//     _pincodeCtrl.dispose();
//     super.dispose();
//   }

//   // Convert cart to items array format expected by API
//   List<Map<String, dynamic>> _getCartItems() {
//     List<Map<String, dynamic>> items = [];
//     for (var item in widget.cart.values) {
//       final product = item['product'] as ProductModel;
//       final quantity = item['quantity'] as int;
//       items.add({
//         'productId': product.id,
//         'quantity': quantity,
//       });
//     }
//     return items;
//   }

//   Future<void> _submit() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isPlacingOrder = true);
      
//       final provider = Provider.of<OrderProvider>(context, listen: false);
      
//       // Get all cart items
//       final items = _getCartItems();
      
//       // Place single order with all products
//       final result = await provider.placeOrderWithAddress(x
//         items: items,
//         addressId: addre,
//       );
      
//       setState(() => _isPlacingOrder = false);
      
//       if (result['success']) {
//         // Close the manual address sheet first
//         if (mounted) {
//           Navigator.pop(context); // Close manual address sheet
          
//           // Show success message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Order placed to ${_flatCtrl.text}, ${_areaCtrl.text}, ${_cityCtrl.text}'),
//               backgroundColor: kGreen,
//             ),
//           );
          
//           // Call onOrderPlaced to clear cart
//           widget.onOrderPlaced();
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(result['message'])),
//           );
//         }
//       }
//     }
//   }

//   // Rest of the UI remains the same...
//   InputDecoration _inputDecor(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Color(0xFF888780), fontSize: 13),
//       prefixIcon: Icon(icon, color: const Color(0xFFB4B2A9), size: 18),
//       filled: true,
//       fillColor: const Color(0xFFF5F6FA),
//       contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 0.5),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 0.5),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: kGreen, width: 1.5),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 1),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 1.5),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Handle
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE0E0E0),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),

//                 // Header
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                         showModalBottomSheet(
//                           context: context,
//                           isScrollControlled: true,
//                           backgroundColor: Colors.transparent,
//                           builder: (_) => DeliveryLocationSheet(
//                             cart: widget.cart,
//                             totalPrice: widget.totalPrice,
//                             onOrderPlaced: widget.onOrderPlaced,
//                           ),
//                         );
//                       },
//                       child: const Icon(
//                         Icons.arrow_back_ios_new_rounded,
//                         size: 18,
//                         color: Color(0xFF2C2C2A),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'Enter Delivery Address',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2C2C2A),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Name
//                 TextFormField(
//                   controller: _nameCtrl,
//                   decoration: _inputDecor(
//                     'Full Name',
//                     Icons.person_outline_rounded,
//                   ),
//                   validator: (v) => (v == null || v.trim().isEmpty)
//                       ? 'Enter your name'
//                       : null,
//                 ),
//                 const SizedBox(height: 12),

//                 // Phone
//                 TextFormField(
//                   controller: _phoneCtrl,
//                   keyboardType: TextInputType.phone,
//                   decoration: _inputDecor('Phone Number', Icons.phone_outlined),
//                   validator: (v) {
//                     if (v == null || v.trim().isEmpty)
//                       return 'Enter phone number';
//                     if (v.trim().length < 10) return 'Enter valid phone number';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),

//                 // Flat / House No
//                 TextFormField(
//                   controller: _flatCtrl,
//                   decoration: _inputDecor(
//                     'Flat / House No / Building',
//                     Icons.home_outlined,
//                   ),
//                   validator: (v) => (v == null || v.trim().isEmpty)
//                       ? 'Enter flat/house no'
//                       : null,
//                 ),
//                 const SizedBox(height: 12),

//                 // Area / Street
//                 TextFormField(
//                   controller: _areaCtrl,
//                   decoration: _inputDecor(
//                     'Area / Street / Locality',
//                     Icons.streetview_rounded,
//                   ),
//                   validator: (v) => (v == null || v.trim().isEmpty)
//                       ? 'Enter area/street'
//                       : null,
//                 ),
//                 const SizedBox(height: 12),

//                 // City & Pincode side by side
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _cityCtrl,
//                         decoration: _inputDecor(
//                           'City',
//                           Icons.location_city_outlined,
//                         ),
//                         validator: (v) => (v == null || v.trim().isEmpty)
//                             ? 'Enter city'
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _pincodeCtrl,
//                         keyboardType: TextInputType.number,
//                         decoration: _inputDecor('Pincode', Icons.pin_outlined),
//                         validator: (v) {
//                           if (v == null || v.trim().isEmpty)
//                             return 'Enter pincode';
//                           if (v.trim().length != 6) return 'Invalid pincode';
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),

//                 // Order Summary
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F6FA),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Total Amount',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF2C2C2A),
//                         ),
//                       ),
//                       Text(
//                         '₹${widget.totalPrice}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: kGreen,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Confirm Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _isPlacingOrder ? null : _submit,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: kGreen,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: _isPlacingOrder
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Text(
//                             'Confirm & Place Order',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }