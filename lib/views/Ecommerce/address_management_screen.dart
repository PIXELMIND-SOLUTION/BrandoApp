import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Ecommerce/address_provider.dart';
import '../../models/Ecommerce/address_model.dart';

class AddressManagementScreen extends StatefulWidget {
  final Function(AddressModel? selectedAddress)? onAddressSelected;
  
  const AddressManagementScreen({super.key, this.onAddressSelected});

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  void _showAddressForm({AddressModel? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddressFormModal(
        address: address,
        onSave: () {
          Navigator.pop(context);
          Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
        },
      ),
    );
  }

  Future<void> _confirmDelete(String addressId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await Provider.of<AddressProvider>(context, listen: false)
          .deleteAddress(addressId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Consumer<AddressProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchAddresses(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No addresses added yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddressForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D9E75),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.addresses.length,
            itemBuilder: (context, index) {
              final address = provider.addresses[index];
              return _AddressCard(
                address: address,
                onEdit: () => _showAddressForm(address: address),
                onDelete: () => _confirmDelete(address.id),
                onSelect: widget.onAddressSelected != null
                    ? () => widget.onAddressSelected!(address)
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressForm(),
        backgroundColor: const Color(0xFF1D9E75),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSelect;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    address.addressType == 'home' ? Icons.home : Icons.business,
                    size: 20,
                    color: const Color(0xFF1D9E75),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3DE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Default',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1D9E75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                address.phone,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                address.formattedAddress,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressFormModal extends StatefulWidget {
  final AddressModel? address;
  final VoidCallback onSave;

  const AddressFormModal({super.key, this.address, required this.onSave});

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

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.address?.fullName ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _flatNoController = TextEditingController(text: widget.address?.flatNo ?? '');
    _areaController = TextEditingController(text: widget.address?.area ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _pincodeController = TextEditingController(text: widget.address?.pincode ?? '');
    _isDefault = widget.address?.isDefault ?? false;
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
      final provider = Provider.of<AddressProvider>(context, listen: false);
      bool success;

      if (widget.address == null) {
        success = await provider.addAddress(
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          flatNo: _flatNoController.text,
          area: _areaController.text,
          city: _cityController.text,
          pincode: _pincodeController.text,
          isDefault: _isDefault,
        );
      } else {
        success = await provider.updateAddress(
          addressId: widget.address!.id,
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          flatNo: _flatNoController.text,
          area: _areaController.text,
          city: _cityController.text,
          pincode: _pincodeController.text,
          isDefault: _isDefault,
        );
      }

      if (success && mounted) {
        widget.onSave();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.address == null
                ? 'Address added successfully'
                : 'Address updated successfully'),
          ),
        );
        Navigator.pop(context);
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
              Text(
                widget.address == null ? 'Add New Address' : 'Edit Address',
                style: const TextStyle(
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
              CheckboxListTile(
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value ?? false;
                  });
                },
                title: const Text('Set as default address'),
                activeColor: const Color(0xFF1D9E75),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 20),
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
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9E75),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save'),
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