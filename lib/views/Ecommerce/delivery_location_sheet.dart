import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../provider/Ecommerce/order_provider.dart';
import '../../provider/Ecommerce/address_provider.dart';
import '../../models/Ecommerce/address_model.dart';
import 'address_management_screen.dart';

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
  AddressModel? _selectedAddress;
  bool _isLoading = true;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final provider = Provider.of<AddressProvider>(context, listen: false);
    await provider.fetchAddresses();
    setState(() {
      _selectedAddress = provider.defaultAddress;
      _isLoading = false;
    });
  }

  // Show address form directly (no navigation to manage screen)
  void _showAddressForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddressFormModal(
        onSave: () async {
          Navigator.pop(context); // Close the form modal
          await _loadAddresses(); // Reload addresses after saving
        },
      ),
    );
  }
// Show edit address form
void _showEditAddressForm(AddressModel address) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => EditAddressFormModal(
      address: address,
      onSave: () async {
        Navigator.pop(context); // Close the form modal
        await _loadAddresses(); // Reload addresses after editing
      },
    ),
  );
}
  // Place order using current location directly
  Future<void> _placeOrderWithCurrentLocation() async {
    setState(() {
      _isPlacingOrder = true;
    });

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          setState(() {
            _isPlacingOrder = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission permanently denied'),
          ),
        );
        setState(() {
          _isPlacingOrder = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Prepare order items
      final orderItems = widget.cart.entries.map((entry) {
        final product = entry.value['product'];
        final quantity = entry.value['quantity'];
        return {
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': quantity,
          'image': product.image,
        };
      }).toList();

      // Place order with live location
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final result = await orderProvider.placeOrderWithLiveLocation(
        items: orderItems,
        latitude: position.latitude,
        longitude: position.longitude,
      );
      
      print("resultttttttttttttttttttt${result['success']}");
      
      if (result['success'] && mounted) {
        widget.onOrderPlaced();
        Navigator.pop(context); // Close the delivery location sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to place order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  // Place order using saved address
  Future<void> _placeOrderWithAddress() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    // Convert cart items to order items format
    final orderItems = widget.cart.entries.map((entry) {
      final product = entry.value['product'];
      final quantity = entry.value['quantity'];
      return {
        'productId': product.id,
        'quantity': quantity,
      };
    }).toList();
    final result = await orderProvider.placeOrderWithAddress(
      addressId: _selectedAddress!.id,
      items: orderItems,
    );
print("llllhhhhhggggfffff${result['success']}");

    setState(() {
      _isPlacingOrder = false;
    });

    if (result['success']) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to place order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF1D9E75)),
                SizedBox(width: 8),
                Text(
                  'Select Delivery Option',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          
          // Current Location Button (Direct Order)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _isPlacingOrder ? null : _placeOrderWithCurrentLocation,
                  icon: _isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    _isPlacingOrder ? 'Placing order...' : 'Use Current Location & Place Order',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9E75),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ll deliver to your current location',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // OR divider
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR Deliver to Saved Address',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Saved Addresses Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Consumer<AddressProvider>(
                    builder: (context, provider, child) {
                      if (provider.addresses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_off,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No saved addresses',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _showAddressForm, // Directly open form
                                icon: const Icon(Icons.add),
                                label: const Text('Add New Address'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1D9E75),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return Column(
                        children: [
                          // Add address button at top
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: OutlinedButton.icon(
                              onPressed: _showAddressForm, // Directly open form
                              icon: const Icon(Icons.add_location, size: 18),
                              label: const Text('New Address'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1D9E75),
                                side: const BorderSide(color: Color(0xFF1D9E75)),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          // Address list
               // Address list - Updated with edit button
Expanded(
  child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: provider.addresses.length,
    itemBuilder: (context, index) {
      final address = provider.addresses[index];
      final isSelected = _selectedAddress?.id == address.id;
      
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedAddress = address;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEAF3DE)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1D9E75)
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Radio<AddressModel>(
                value: address,
                groupValue: _selectedAddress,
                onChanged: (value) {
                  setState(() {
                    _selectedAddress = value;
                  });
                },
                activeColor: const Color(0xFF1D9E75),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (address.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1D9E75)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF1D9E75),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.phone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.formattedAddress,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Edit Button
              IconButton(
                onPressed: () => _showEditAddressForm(address),
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: const Color(0xFF1D9E75),
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
                  ),
          ),
          
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
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
                      ),
                    ),
                    Text(
                      '₹${widget.totalPrice}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D9E75),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isPlacingOrder || _selectedAddress == null
                      ? null
                      : _placeOrderWithAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9E75),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isPlacingOrder
                        ? 'Placing Order...'
                        : 'Deliver to ${_selectedAddress?.fullName?.split(' ').first ?? 'Selected Address'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// Edit Address Form Modal
class EditAddressFormModal extends StatefulWidget {
  final AddressModel address;
  final VoidCallback onSave;

  const EditAddressFormModal({
    super.key, 
    required this.address, 
    required this.onSave
  });

  @override
  State<EditAddressFormModal> createState() => _EditAddressFormModalState();
}

class _EditAddressFormModalState extends State<EditAddressFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _flatNoController;
  late TextEditingController _areaController;
  late TextEditingController _cityController;
  late TextEditingController _pincodeController;
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.address.fullName);
    _phoneController = TextEditingController(text: widget.address.phone);
    _flatNoController = TextEditingController(text: widget.address.flatNo);
    _areaController = TextEditingController(text: widget.address.area);
    _cityController = TextEditingController(text: widget.address.city);
    _pincodeController = TextEditingController(text: widget.address.pincode);
    _isDefault = widget.address.isDefault;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _flatNoController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _updateAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final provider = Provider.of<AddressProvider>(context, listen: false);
      
      final success = await provider.updateAddress(
        addressId: widget.address.id,
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        flatNo: _flatNoController.text,
        area: _areaController.text,
        city: _cityController.text,
        pincode: _pincodeController.text,
        isDefault: _isDefault,
      );

      setState(() {
        _isSaving = false;
      });

      if (success && mounted) {
        widget.onSave();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address updated successfully')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to update address'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Edit Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter full name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please enter phone number';
                  if (value!.length != 10) return 'Enter valid 10-digit number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _flatNoController,
                decoration: const InputDecoration(
                  labelText: 'Flat/House No.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter flat/house number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Area/Locality',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter area' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter city' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_post_office),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please enter pincode';
                  if (value!.length != 6) return 'Enter valid 6-digit pincode';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // CheckboxListTile(
              //   value: _isDefault,
              //   onChanged: (value) {
              //     setState(() {
              //       _isDefault = value ?? false;
              //     });
              //   },
              //   title: const Text('Set as default address'),
              //   activeColor: const Color(0xFF1D9E75),
              //   contentPadding: EdgeInsets.zero,
              //   controlAffinity: ListTileControlAffinity.leading,
              // ),
              // const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _updateAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9E75),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Update'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
// Address Form Modal (Directly in delivery location sheet)
class AddressFormModal extends StatefulWidget {
  final VoidCallback onSave;

  const AddressFormModal({super.key, required this.onSave});

  @override
  State<AddressFormModal> createState() => _AddressFormModalState();
}

class _AddressFormModalState extends State<AddressFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _flatNoController;
  late TextEditingController _areaController;
  late TextEditingController _cityController;
  late TextEditingController _pincodeController;
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _flatNoController = TextEditingController();
    _areaController = TextEditingController();
    _cityController = TextEditingController();
    _pincodeController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _flatNoController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final provider = Provider.of<AddressProvider>(context, listen: false);
      
      final success = await provider.addAddress(
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        flatNo: _flatNoController.text,
        area: _areaController.text,
        city: _cityController.text,
        pincode: _pincodeController.text,
        isDefault: _isDefault,
      );

      setState(() {
        _isSaving = false;
      });

      if (success && mounted) {
        widget.onSave();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added successfully')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to save address'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter full name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please enter phone number';
                  if (value!.length != 10) return 'Enter valid 10-digit number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _flatNoController,
                decoration: const InputDecoration(
                  labelText: 'Flat/House No.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter flat/house number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Area/Locality',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter area' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter city' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_post_office),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please enter pincode';
                  if (value!.length != 6) return 'Enter valid 6-digit pincode';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // CheckboxListTile(
              //   value: _isDefault,
              //   onChanged: (value) {
              //     setState(() {
              //       _isDefault = value ?? false;
              //     });
              //   },
              //   title: const Text('Set as default address'),
              //   activeColor: const Color(0xFF1D9E75),
              //   contentPadding: EdgeInsets.zero,
              //   controlAffinity: ListTileControlAffinity.leading,
              // ),
              // const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9E75),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}