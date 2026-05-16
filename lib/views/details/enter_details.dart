// import 'dart:convert';
// import 'dart:io';
// import 'package:brando_app/constant/api_constants.dart';
// import 'package:brando_app/models/submit_hostel_model.dart';
// import 'package:brando_app/provider/booking/submit_form_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// class EnterDetails extends StatefulWidget {
//   final String bookingId;
//   final String hostelId;

//   const EnterDetails({
//     super.key,
//     required this.bookingId,
//     required this.hostelId,
//   });

//   @override
//   State<EnterDetails> createState() => _EnterDetailsState();
// }

// class _EnterDetailsState extends State<EnterDetails> {
//   final _formKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _emobileController = TextEditingController();
//   final _roomNoController = TextEditingController();

//   // Room selection variables
//   String? _selectedRoomType; // 'AC' or 'Non-AC'
//   String? _selectedShareType; // '1 Share', '2 Share', etc.
//   String? _selectedRoomNumber;

//   // Booking type and amount variables
//   String? _selectedBookingType; // 'monthly' or 'daily'
//   int _totalAmount = 0;
//   bool _showBookingTypeSelector = false;

//   List<SharingOption> _sharingOptions = [];
//   List<String> _roomTypes = [];
//   List<String> _shareTypes = [];
//   List<String> _roomNumbers = [];

//   bool _isLoadingRoomNumbers = true;
//   bool _isManualEntry = false;
//   String? _roomNumbersError;

//   // Store multiple images for Aadhar and PAN
//   List<String> _aadharImagePaths = [];
//   List<String> _panImagePaths = [];
//   String? _profileImagePath;

//   final _picker = ImagePicker();

//   // Maximum images allowed per document
//   static const int _maxImagesPerDocument = 2;

//   @override
//   void initState() {
//     super.initState();
//     _fetchRoomOptions();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileController.dispose();
//     _emobileController.dispose();
//     _roomNoController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchRoomOptions() async {
//     setState(() {
//       _isLoadingRoomNumbers = true;
//       _roomNumbersError = null;
//     });

//     try {
//       final url = Uri.parse(
//         '${ApiConstants.baseUrl}/api/admin/hostelroom-numbers/${widget.hostelId}',
//       );
//       final response = await http.get(url);

//       print('Room options response status: ${response.statusCode}');
//       print('Room options response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final List<dynamic> sharings = data['sharings'] ?? [];

//           setState(() {
//             _sharingOptions = sharings
//                 .map((sharing) => SharingOption.fromJson(sharing))
//                 .toList();

//             // Extract unique room types
//             _roomTypes = _sharingOptions
//                 .map((opt) => opt.type)
//                 .toSet()
//                 .toList();

//             _isLoadingRoomNumbers = false;

//             if (_sharingOptions.isEmpty) {
//               _isManualEntry = true;
//             }
//           });
//         } else {
//           setState(() {
//             _roomNumbersError =
//                 data['message'] ?? 'Failed to load room options';
//             _isLoadingRoomNumbers = false;
//             _isManualEntry = true;
//           });
//         }
//       } else {
//         setState(() {
//           _roomNumbersError =
//               'Failed to load room options. Please enter manually.';
//           _isLoadingRoomNumbers = false;
//           _isManualEntry = true;
//         });
//       }
//     } catch (e) {
//       print('Error fetching room options: $e');
//       setState(() {
//         _roomNumbersError = 'Network error. Please enter room number manually.';
//         _isLoadingRoomNumbers = false;
//         _isManualEntry = true;
//       });
//     }
//   }

//   // Update share types when room type changes
//   void _onRoomTypeChanged(String? roomType) {
//     setState(() {
//       _selectedRoomType = roomType;
//       _selectedShareType = null;
//       _selectedRoomNumber = null;
//       _selectedBookingType = null;
//       _totalAmount = 0;
//       _showBookingTypeSelector = false;

//       if (roomType != null) {
//         // Get unique share types for selected room type
//         _shareTypes = _sharingOptions
//             .where((opt) => opt.type == roomType)
//             .map((opt) => opt.shareType)
//             .toSet()
//             .toList();
//       } else {
//         _shareTypes = [];
//       }
//     });
//   }

//   // Update room numbers and booking type options when share type changes
//   void _onShareTypeChanged(String? shareType) {
//     setState(() {
//       _selectedShareType = shareType;
//       _selectedRoomNumber = null;
//       _selectedBookingType = null;
//       _totalAmount = 0;

//       if (shareType != null && _selectedRoomType != null) {
//         // Get room numbers for selected room type and share type
//         final option = _sharingOptions.firstWhere(
//           (opt) => opt.type == _selectedRoomType && opt.shareType == shareType,
//           orElse: () => SharingOption(
//             type: '',
//             shareType: '',
//             monthlyPrice: 0,
//             dailyPrice: 0,
//             roomNumbers: [],
//           ),
//         );
//         _roomNumbers = option.roomNumbers;

//         // Check if booking type selector should be shown
//         _showBookingTypeSelector =
//             option.monthlyPrice > 0 || option.dailyPrice > 0;

//         // Auto-select booking type if only one option is available
//         if (option.monthlyPrice > 0 && option.dailyPrice == 0) {
//           _selectedBookingType = 'monthly';
//           _totalAmount = option.monthlyPrice;
//         } else if (option.monthlyPrice == 0 && option.dailyPrice > 0) {
//           _selectedBookingType = 'daily';
//           _totalAmount = option.dailyPrice;
//         }
//       } else {
//         _roomNumbers = [];
//         _showBookingTypeSelector = false;
//       }
//     });
//   }

//   // Update total amount when booking type changes
//   void _onBookingTypeChanged(String? bookingType) {
//     if (bookingType == null ||
//         _selectedRoomType == null ||
//         _selectedShareType == null)
//       return;

//     final option = _sharingOptions.firstWhere(
//       (opt) =>
//           opt.type == _selectedRoomType && opt.shareType == _selectedShareType,
//       orElse: () => SharingOption(
//         type: '',
//         shareType: '',
//         monthlyPrice: 0,
//         dailyPrice: 0,
//         roomNumbers: [],
//       ),
//     );

//     setState(() {
//       _selectedBookingType = bookingType;
//       if (bookingType == 'monthly') {
//         _totalAmount = option.monthlyPrice;
//       } else if (bookingType == 'daily') {
//         _totalAmount = option.dailyPrice;
//       }
//     });
//   }

//   // Method for taking selfie with front camera only
//   Future<void> _takeSelfie(String type) async {
//     try {
//       final XFile? picked = await _picker.pickImage(
//         source: ImageSource.camera,
//         preferredCameraDevice: CameraDevice.front,
//         imageQuality: 85,
//       );

//       if (picked == null) return;

//       setState(() {
//         if (type == 'profile') {
//           _profileImagePath = picked.path;
//         }
//       });
//     } catch (e) {
//       print('Error taking selfie: $e');
//       _showSnack('Failed to take selfie. Please try again.');
//     }
//   }

//   // Method to pick document images with multi-image support
//   Future<void> _pickDocumentImage(String documentType, int sideIndex) async {
//     final picked = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85,
//     );

//     if (picked == null) return;

//     setState(() {
//       if (documentType == 'aadhar') {
//         if (_aadharImagePaths.length < _maxImagesPerDocument) {
//           _aadharImagePaths.add(picked.path);
//         } else {
//           _showSnack(
//             'Maximum $_maxImagesPerDocument images allowed for Aadhar Card',
//           );
//         }
//       } else if (documentType == 'pan') {
//         if (_panImagePaths.length < _maxImagesPerDocument) {
//           _panImagePaths.add(picked.path);
//         } else {
//           _showSnack(
//             'Maximum $_maxImagesPerDocument images allowed for Photo ID Card',
//           );
//         }
//       }
//     });
//   }

//   // Method to take document photos with camera
//   Future<void> _takeDocumentPhoto(String documentType, int sideIndex) async {
//     try {
//       final XFile? picked = await _picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 85,
//       );

//       if (picked == null) return;

//       setState(() {
//         if (documentType == 'aadhar') {
//           if (_aadharImagePaths.length < _maxImagesPerDocument) {
//             _aadharImagePaths.add(picked.path);
//           } else {
//             _showSnack(
//               'Maximum $_maxImagesPerDocument images allowed for Aadhar Card',
//             );
//           }
//         } else if (documentType == 'pan') {
//           if (_panImagePaths.length < _maxImagesPerDocument) {
//             _panImagePaths.add(picked.path);
//           } else {
//             _showSnack(
//               'Maximum $_maxImagesPerDocument images allowed for Photo ID Card',
//             );
//           }
//         }
//       });
//     } catch (e) {
//       print('Error taking photo: $e');
//       _showSnack('Failed to take photo. Please try again.');
//     }
//   }

//   // Show image source dialog for document uploads
//   void _showImageSourceDialog(String documentType, int sideIndex) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 12),
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.red),
//               title: const Text('Take Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _takeDocumentPhoto(documentType, sideIndex);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: Colors.red),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickDocumentImage(documentType, sideIndex);
//               },
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }

//   // Remove a specific image from document
//   void _removeDocumentImage(String documentType, int index) {
//     setState(() {
//       if (documentType == 'aadhar') {
//         _aadharImagePaths.removeAt(index);
//       } else if (documentType == 'pan') {
//         _panImagePaths.removeAt(index);
//       }
//     });
//   }

//   // Profile photo - camera only
//   Future<void> _pickProfileImage() async {
//     _takeSelfie('profile');
//   }

//   Future<void> _onProceed() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_isManualEntry) {
//       if (_roomNoController.text.trim().isEmpty) {
//         _showSnack('Please enter a room number.');
//         return;
//       }
//     } else {
//       if (_selectedRoomType == null) {
//         _showSnack('Please select room type (AC/Non-AC).');
//         return;
//       }
//       if (_selectedShareType == null) {
//         _showSnack('Please select share type.');
//         return;
//       }
//       if (_selectedRoomNumber == null) {
//         _showSnack('Please select a room number.');
//         return;
//       }
//       if (_selectedBookingType == null) {
//         _showSnack('Please select booking type (Monthly/Daily).');
//         return;
//       }
//       if (_totalAmount == 0) {
//         _showSnack('Invalid amount selected.');
//         return;
//       }
//     }

//     if (_mobileController.text.trim().isEmpty) {
//       _showSnack('Please enter mobile number.');
//       return;
//     }

//     if (_emobileController.text.trim().isEmpty) {
//       _showSnack('Please enter emergency mobile number.');
//       return;
//     }

//     if (_nameController.text.trim().isEmpty) {
//       _showSnack('Please enter name.');
//       return;
//     }

//     // Validation for multiple images
//     if (_aadharImagePaths.isEmpty) {
//       _showSnack('Please upload at least one Aadhar Card image.');
//       return;
//     }

//     if (_panImagePaths.isEmpty) {
//       _showSnack('Please upload at least one PAN Card image.');
//       return;
//     }

//     if (_profileImagePath == null) {
//       _showSnack('Please take your Profile Photo (Selfie).');
//       return;
//     }

//     final roomNumber = _isManualEntry
//         ? _roomNoController.text.trim()
//         : _selectedRoomNumber!;

//     final roomType = _isManualEntry ? '' : (_selectedRoomType ?? '');
//     final shareType = _isManualEntry ? '' : (_selectedShareType ?? '');
//     final bookingType = _isManualEntry ? '' : (_selectedBookingType ?? '');
//     final totalAmount = _isManualEntry ? 0 : _totalAmount;

//     // Create request with multiple images and booking details
//     final request = HostelBookingRequestModel(
//       name: _nameController.text.trim(),
//       mobileNumber: _mobileController.text.trim(),
//       email: '',
//       roomNo: roomNumber,
//       roomType: roomType,
//       shareType: shareType,
//       bookingType: bookingType,
//       totalAmount: totalAmount,
//       aadharCardImage: _aadharImagePaths,
//       panCardImage: _panImagePaths,
//       profileImage: _profileImagePath!,
//       emergencyNumber: _emobileController.text.trim(),
//     );

//     final provider = context.read<HostelBookingProvider>();
//     final success = await provider.submitBooking(
//       bookingId: widget.bookingId,
//       request: request,
//     );

//     if (!mounted) return;

//     if (success) {
//       _showSuccessDialog();
//     } else {
//       _showSnack(provider.errorMessage ?? 'Booking failed. Please try again.');
//     }
//   }

//   void _showSnack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         contentPadding: const EdgeInsets.all(24),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 64,
//               height: 64,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFFEBEE),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check_circle,
//                 color: Colors.red,
//                 size: 36,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Booking Submitted!',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Your booking request has been submitted successfully. You will be notified once confirmed.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey, fontSize: 13),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Done',
//                   style: TextStyle(color: Colors.white, fontSize: 15),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => HostelBookingProvider(),
//       child: Builder(builder: (ctx) => _buildScaffold(ctx)),
//     );
//   }

//   Widget _buildScaffold(BuildContext ctx) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         title: RichText(
//           text: const TextSpan(
//             children: [
//               TextSpan(
//                 text: 'Enter ',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               TextSpan(
//                 text: 'Details',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           children: [
//             _buildSectionLabel('Profile Photo (Selfie)'),
//             const SizedBox(height: 10),
//             _buildProfilePicker(),
//             const SizedBox(height: 24),
//             _buildSectionLabel('Personal Information'),
//             const SizedBox(height: 12),
//             _buildTextField(
//               controller: _nameController,
//               label: 'Full Name',
//               hint: 'Enter your full name',
//               icon: Icons.person_outline,
//               validator: (v) =>
//                   v == null || v.trim().isEmpty ? 'Name is required' : null,
//             ),
//             const SizedBox(height: 14),
//             _buildTextField(
//               controller: _mobileController,
//               label: 'Mobile Number',
//               hint: '10-digit mobile number',
//               icon: Icons.phone_outlined,
//               keyboardType: TextInputType.phone,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//               validator: (v) {
//                 if (v == null || v.trim().isEmpty) return 'Mobile is required';
//                 if (v.trim().length != 10)
//                   return 'Enter a valid 10-digit number';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 14),
//             _buildTextField(
//               controller: _emobileController,
//               label: 'Emergency Number',
//               hint: '10-digit mobile number',
//               icon: Icons.phone_outlined,
//               keyboardType: TextInputType.phone,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//               validator: (v) {
//                 if (v == null || v.trim().isEmpty) return 'Mobile is required';
//                 if (v.trim().length != 10)
//                   return 'Enter a valid 10-digit number';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 24),
//             _buildSectionLabel('Room Details'),
//             const SizedBox(height: 12),
//             _buildRoomDetailsSection(),
//             const SizedBox(height: 24),
//             _buildSectionLabel('Upload Documents'),
//             const SizedBox(height: 12),
//             _buildMultiImageUploadTile(
//               label: 'Aadhar Card',
//               subtitle: 'Upload front and back sides (Max 2 images)',
//               icon: Icons.badge_outlined,
//               imagePaths: _aadharImagePaths,
//               maxImages: _maxImagesPerDocument,
//               onAddImage: (sideIndex) =>
//                   _showImageSourceDialog('aadhar', sideIndex),
//               onRemoveImage: (index) => _removeDocumentImage('aadhar', index),
//             ),
//             const SizedBox(height: 12),
//             _buildMultiImageUploadTile(
//               label: 'Photo ID Card',
//               subtitle: 'Upload front and back sides (Max 2 images)',
//               icon: Icons.credit_card_outlined,
//               imagePaths: _panImagePaths,
//               maxImages: _maxImagesPerDocument,
//               onAddImage: (sideIndex) =>
//                   _showImageSourceDialog('pan', sideIndex),
//               onRemoveImage: (index) => _removeDocumentImage('pan', index),
//             ),
//             const SizedBox(height: 32),
//             Consumer<HostelBookingProvider>(
//               builder: (_, provider, __) => SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed: provider.isLoading ? null : _onProceed,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     disabledBackgroundColor: Colors.red.withOpacity(0.6),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: provider.isLoading
//                       ? const SizedBox(
//                           width: 22,
//                           height: 22,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.5,
//                           ),
//                         )
//                       : const Text(
//                           'Proceed',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoomDetailsSection() {
//     if (_isLoadingRoomNumbers) {
//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFAFAFA),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: const Color(0xFFE0E0E0)),
//         ),
//         child: const Row(
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//             SizedBox(width: 12),
//             Text('Loading room options...'),
//           ],
//         ),
//       );
//     }

//     if (_sharingOptions.isNotEmpty && !_isManualEntry) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Room Type Dropdown (AC/Non-AC)
//           _buildDropdown(
//             label: 'Room Type',
//             hint: 'Select AC or Non-AC',
//             icon: Icons.ac_unit_outlined,
//             value: _selectedRoomType,
//             items: _roomTypes,
//             onChanged: _onRoomTypeChanged,
//             validator: (v) => v == null ? 'Please select room type' : null,
//           ),
//           const SizedBox(height: 14),

//           // Share Type Dropdown (1 Share, 2 Share, etc.)
//           if (_selectedRoomType != null)
//             _buildDropdown(
//               label: 'Share Type',
//               hint: 'Select sharing type',
//               icon: Icons.people_outline,
//               value: _selectedShareType,
//               items: _shareTypes,
//               onChanged: _onShareTypeChanged,
//               validator: (v) => v == null ? 'Please select share type' : null,
//             ),

//           if (_selectedShareType != null) const SizedBox(height: 14),

//           // Room Number Dropdown
//           if (_selectedShareType != null && _roomNumbers.isNotEmpty)
//             _buildDropdown(
//               label: 'Room Number',
//               hint: 'Select room number',
//               icon: Icons.door_back_door_outlined,
//               value: _selectedRoomNumber,
//               items: _roomNumbers,
//               onChanged: (val) => setState(() => _selectedRoomNumber = val),
//               validator: (v) => v == null ? 'Please select room number' : null,
//             ),

//           // Booking Type Selection (Monthly/Daily)
//           if (_selectedRoomNumber != null && _showBookingTypeSelector)
//             _buildBookingTypeSelector(),

//           // Price information
//           if (_selectedBookingType != null && _totalAmount > 0)
//             _buildTotalAmountCard(),

//           // const SizedBox(height: 8),
//           // Row(
//           //   children: [
//           //     const Text(
//           //       'Room not listed?',
//           //       style: TextStyle(fontSize: 12, color: Colors.grey),
//           //     ),
//           //     TextButton(
//           //       onPressed: () {
//           //         setState(() {
//           //           _isManualEntry = true;
//           //           _selectedRoomType = null;
//           //           _selectedShareType = null;
//           //           _selectedRoomNumber = null;
//           //           _selectedBookingType = null;
//           //           _totalAmount = 0;
//           //           _showBookingTypeSelector = false;
//           //         });
//           //       },
//           //       style: TextButton.styleFrom(
//           //         padding: const EdgeInsets.symmetric(horizontal: 8),
//           //         minimumSize: Size.zero,
//           //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           //       ),
//           //       child: const Text(
//           //         'Enter manually',
//           //         style: TextStyle(fontSize: 12, color: Colors.red),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//         ],
//       );
//     }

//     // Manual entry mode
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildTextField(
//           controller: _roomNoController,
//           label: 'Room Number',
//           hint: 'e.g., 101, G1, 202',
//           icon: Icons.door_back_door_outlined,
//           validator: (v) =>
//               v == null || v.trim().isEmpty ? 'Room number is required' : null,
//         ),
//         if (_sharingOptions.isNotEmpty) ...[
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               const Text(
//                 'Want to select from available rooms?',
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _isManualEntry = false;
//                     _roomNoController.clear();
//                   });
//                 },
//                 style: TextButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   minimumSize: Size.zero,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 ),
//                 child: const Text(
//                   'Select from list',
//                   style: TextStyle(fontSize: 12, color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ],
//         if (_roomNumbersError != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Text(
//               _roomNumbersError!,
//               style: const TextStyle(fontSize: 11, color: Colors.orange),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildBookingTypeSelector() {
//     if (_selectedRoomType == null || _selectedShareType == null)
//       return const SizedBox.shrink();

//     final option = _sharingOptions.firstWhere(
//       (opt) =>
//           opt.type == _selectedRoomType && opt.shareType == _selectedShareType,
//       orElse: () => SharingOption(
//         type: '',
//         shareType: '',
//         monthlyPrice: 0,
//         dailyPrice: 0,
//         roomNumbers: [],
//       ),
//     );

//     final hasMonthly = option.monthlyPrice > 0;
//     final hasDaily = option.dailyPrice > 0;

//     if (!hasMonthly && !hasDaily) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 14),
//         const Text(
//           'Booking Type',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             if (hasMonthly)
//               Expanded(
//                 child: _buildBookingTypeCard(
//                   title: 'Monthly',
//                   amount: option.monthlyPrice,
//                   isSelected: _selectedBookingType == 'monthly',
//                   onTap: () => _onBookingTypeChanged('monthly'),
//                 ),
//               ),
//             if (hasMonthly && hasDaily) const SizedBox(width: 12),
//             if (hasDaily)
//               Expanded(
//                 child: _buildBookingTypeCard(
//                   title: 'Daily',
//                   amount: option.dailyPrice,
//                   isSelected: _selectedBookingType == 'daily',
//                   onTap: () => _onBookingTypeChanged('daily'),
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildBookingTypeCard({
//     required String title,
//     required int amount,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFFFFEBEE) : const Color(0xFFFAFAFA),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.red : const Color(0xFFE0E0E0),
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? Colors.red : Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '₹$amount',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: isSelected ? Colors.red : Colors.black87,
//               ),
//             ),
//             if (title == 'Monthly')
//               Text(
//                 'per month',
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: isSelected ? Colors.red : Colors.grey,
//                 ),
//               )
//             else
//               Text(
//                 'per day',
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: isSelected ? Colors.red : Colors.grey,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTotalAmountCard() {
//     return Container(
//       margin: const EdgeInsets.only(top: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.red.shade50, Colors.red.shade100],
//         ),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.red, width: 1),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Total Amount:',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '₹$_totalAmount',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//               Text(
//                 _selectedBookingType == 'monthly' ? 'per month' : 'per day',
//                 style: const TextStyle(fontSize: 11, color: Colors.grey),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMultiImageUploadTile({
//     required String label,
//     required String subtitle,
//     required IconData icon,
//     required List<String> imagePaths,
//     required int maxImages,
//     required void Function(int sideIndex) onAddImage,
//     required void Function(int index) onRemoveImage,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: imagePaths.isNotEmpty
//             ? const Color(0xFFFFF3F3)
//             : const Color(0xFFFAFAFA),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: imagePaths.isNotEmpty
//               ? Colors.red.withOpacity(0.5)
//               : const Color(0xFFE0E0E0),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.red, size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: imagePaths.isNotEmpty ? Colors.red : Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (imagePaths.length < maxImages)
//                 IconButton(
//                   onPressed: () => onAddImage(imagePaths.length),
//                   icon: const Icon(
//                     Icons.add_a_photo,
//                     color: Colors.red,
//                     size: 24,
//                   ),
//                   tooltip: 'Add image',
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           if (imagePaths.isNotEmpty)
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//                 childAspectRatio: 1,
//               ),
//               itemCount: imagePaths.length,
//               itemBuilder: (context, index) {
//                 return Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.file(
//                         File(imagePaths[index]),
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         height: double.infinity,
//                       ),
//                     ),
//                     Positioned(
//                       top: 4,
//                       right: 4,
//                       child: GestureDetector(
//                         onTap: () => onRemoveImage(index),
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Colors.black54,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.close,
//                             size: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 4,
//                       left: 4,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 6,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.black54,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           index == 0 ? 'Front' : 'Back',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           if (imagePaths.isEmpty)
//             GestureDetector(
//               onTap: () => onAddImage(0),
//               child: Center(
//                 child: Container(
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFEBEE),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.red.withOpacity(0.3)),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.cloud_upload, color: Colors.red, size: 28),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Tap to upload ${label.toLowerCase()}',
//                         style: const TextStyle(color: Colors.red, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           if (imagePaths.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Text(
//                 '${imagePaths.length}/$maxImages images uploaded',
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: imagePaths.length == maxImages
//                       ? Colors.green
//                       : Colors.orange,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w700,
//         color: Colors.black87,
//         letterSpacing: 0.3,
//       ),
//     );
//   }

//   Widget _buildProfilePicker() {
//     return Center(
//       child: GestureDetector(
//         onTap: _pickProfileImage,
//         child: Stack(
//           children: [
//             Container(
//               width: 96,
//               height: 96,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFFF5F5F5),
//                 border: Border.all(
//                   color: Colors.red.withOpacity(0.4),
//                   width: 2,
//                 ),
//               ),
//               child: _profileImagePath != null
//                   ? ClipOval(
//                       child: Image.file(
//                         File(_profileImagePath!),
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   : const Icon(Icons.person, size: 44, color: Colors.grey),
//             ),
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: Container(
//                 width: 28,
//                 height: 28,
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.camera_alt,
//                   size: 15,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       inputFormatters: inputFormatters,
//       validator: validator,
//       style: const TextStyle(fontSize: 14, color: Colors.black87),
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
//         prefixIcon: Icon(icon, color: Colors.red, size: 20),
//         labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 14,
//           horizontal: 12,
//         ),
//         filled: true,
//         fillColor: const Color(0xFFFAFAFA),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.red, width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.orange),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String hint,
//     required IconData icon,
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//     String? Function(String?)? validator,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       validator: validator,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
//         prefixIcon: Icon(icon, color: Colors.red, size: 20),
//         labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 14,
//           horizontal: 12,
//         ),
//         filled: true,
//         fillColor: const Color(0xFFFAFAFA),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.red, width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.orange),
//         ),
//       ),
//       dropdownColor: Colors.white,
//       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
//       style: const TextStyle(fontSize: 14, color: Colors.black87),
//       items: items
//           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           .toList(),
//     );
//   }
// }

// // Model class for sharing options
// class SharingOption {
//   final String type;
//   final String shareType;
//   final int monthlyPrice;
//   final int dailyPrice;
//   final List<String> roomNumbers;

//   SharingOption({
//     required this.type,
//     required this.shareType,
//     required this.monthlyPrice,
//     required this.dailyPrice,
//     required this.roomNumbers,
//   });

//   factory SharingOption.fromJson(Map<String, dynamic> json) {
//     return SharingOption(
//       type: json['type'] ?? '',
//       shareType: json['shareType'] ?? '',
//       monthlyPrice: json['monthlyPrice'] ?? 0,
//       dailyPrice: json['dailyPrice'] ?? 0,
//       roomNumbers: List<String>.from(json['roomNumbers'] ?? []),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:brando_app/constant/api_constants.dart';
import 'package:brando_app/models/submit_hostel_model.dart';
import 'package:brando_app/provider/booking/submit_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EnterDetails extends StatefulWidget {
  final String bookingId;
  final String hostelId;

  const EnterDetails({
    super.key,
    required this.bookingId,
    required this.hostelId,
  });

  @override
  State<EnterDetails> createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emobileController = TextEditingController();
  final _roomNoController = TextEditingController();

  // Room selection variables
  String? _selectedRoomType; // 'AC' or 'Non-AC'
  String? _selectedShareType; // '1 Share', '2 Share', etc.
  String? _selectedRoomNumber;

  List<SharingOption> _sharingOptions = [];
  List<String> _roomTypes = [];
  List<String> _shareTypes = [];
  List<String> _roomNumbers = [];

  bool _isLoadingRoomNumbers = true;
  bool _isManualEntry = false;
  String? _roomNumbersError;

  // Store multiple images for Aadhar and PAN
  List<String> _aadharImagePaths = [];
  List<String> _panImagePaths = [];
  String? _profileImagePath;

  final _picker = ImagePicker();

  // Maximum images allowed per document
  static const int _maxImagesPerDocument = 2;

  @override
  void initState() {
    super.initState();
    _fetchRoomOptions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emobileController.dispose();
    _roomNoController.dispose();
    super.dispose();
  }

  Future<void> _fetchRoomOptions() async {
    setState(() {
      _isLoadingRoomNumbers = true;
      _roomNumbersError = null;
    });

    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/admin/hostelroom-numbers/${widget.hostelId}',
      );
      final response = await http.get(url);

      print('Room options response status: ${response.statusCode}');
      print('Room options response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> sharings = data['sharings'] ?? [];

          setState(() {
            _sharingOptions = sharings
                .map((sharing) => SharingOption.fromJson(sharing))
                .toList();

            // Extract unique room types
            _roomTypes = _sharingOptions
                .map((opt) => opt.type)
                .toSet()
                .toList();

            _isLoadingRoomNumbers = false;

            if (_sharingOptions.isEmpty) {
              _isManualEntry = true;
            }
          });
        } else {
          setState(() {
            _roomNumbersError =
                data['message'] ?? 'Failed to load room options';
            _isLoadingRoomNumbers = false;
            _isManualEntry = true;
          });
        }
      } else {
        setState(() {
          _roomNumbersError =
              'Failed to load room options. Please enter manually.';
          _isLoadingRoomNumbers = false;
          _isManualEntry = true;
        });
      }
    } catch (e) {
      print('Error fetching room options: $e');
      setState(() {
        _roomNumbersError = 'Network error. Please enter room number manually.';
        _isLoadingRoomNumbers = false;
        _isManualEntry = true;
      });
    }
  }

  // Update share types when room type changes
  void _onRoomTypeChanged(String? roomType) {
    setState(() {
      _selectedRoomType = roomType;
      _selectedShareType = null;
      _selectedRoomNumber = null;

      if (roomType != null) {
        // Get unique share types for selected room type
        _shareTypes = _sharingOptions
            .where((opt) => opt.type == roomType)
            .map((opt) => opt.shareType)
            .toSet()
            .toList();
      } else {
        _shareTypes = [];
      }
    });
  }

  // Update room numbers when share type changes
  void _onShareTypeChanged(String? shareType) {
    setState(() {
      _selectedShareType = shareType;
      _selectedRoomNumber = null;

      if (shareType != null && _selectedRoomType != null) {
        // Get room numbers for selected room type and share type
        final option = _sharingOptions.firstWhere(
          (opt) => opt.type == _selectedRoomType && opt.shareType == shareType,
          orElse: () => SharingOption(
            type: '',
            shareType: '',
            monthlyPrice: 0,
            dailyPrice: 0,
            roomNumbers: [],
          ),
        );
        _roomNumbers = option.roomNumbers;
      } else {
        _roomNumbers = [];
      }
    });
  }

  // Method for taking selfie with front camera only
  Future<void> _takeSelfie(String type) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        if (type == 'profile') {
          _profileImagePath = picked.path;
        }
      });
    } catch (e) {
      print('Error taking selfie: $e');
      _showSnack('Failed to take selfie. Please try again.');
    }
  }

  // Method to pick document images with multi-image support
  Future<void> _pickDocumentImage(String documentType, int sideIndex) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) return;

    setState(() {
      if (documentType == 'aadhar') {
        if (_aadharImagePaths.length < _maxImagesPerDocument) {
          _aadharImagePaths.add(picked.path);
        } else {
          _showSnack(
            'Maximum $_maxImagesPerDocument images allowed for Aadhar Card',
          );
        }
      } else if (documentType == 'pan') {
        if (_panImagePaths.length < _maxImagesPerDocument) {
          _panImagePaths.add(picked.path);
        } else {
          _showSnack(
            'Maximum $_maxImagesPerDocument images allowed for Photo ID Card',
          );
        }
      }
    });
  }

  // Method to take document photos with camera
  Future<void> _takeDocumentPhoto(String documentType, int sideIndex) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        if (documentType == 'aadhar') {
          if (_aadharImagePaths.length < _maxImagesPerDocument) {
            _aadharImagePaths.add(picked.path);
          } else {
            _showSnack(
              'Maximum $_maxImagesPerDocument images allowed for Aadhar Card',
            );
          }
        } else if (documentType == 'pan') {
          if (_panImagePaths.length < _maxImagesPerDocument) {
            _panImagePaths.add(picked.path);
          } else {
            _showSnack(
              'Maximum $_maxImagesPerDocument images allowed for Photo ID Card',
            );
          }
        }
      });
    } catch (e) {
      print('Error taking photo: $e');
      _showSnack('Failed to take photo. Please try again.');
    }
  }

  // Show image source dialog for document uploads
  void _showImageSourceDialog(String documentType, int sideIndex) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.red),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takeDocumentPhoto(documentType, sideIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.red),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickDocumentImage(documentType, sideIndex);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // Remove a specific image from document
  void _removeDocumentImage(String documentType, int index) {
    setState(() {
      if (documentType == 'aadhar') {
        _aadharImagePaths.removeAt(index);
      } else if (documentType == 'pan') {
        _panImagePaths.removeAt(index);
      }
    });
  }

  // Profile photo - camera only
  Future<void> _pickProfileImage() async {
    _takeSelfie('profile');
  }

  Future<void> _onProceed() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isManualEntry) {
      if (_roomNoController.text.trim().isEmpty) {
        _showSnack('Please enter a room number.');
        return;
      }
    } else {
      if (_selectedRoomType == null) {
        _showSnack('Please select room type (AC/Non-AC).');
        return;
      }
      if (_selectedShareType == null) {
        _showSnack('Please select share type.');
        return;
      }
      if (_selectedRoomNumber == null) {
        _showSnack('Please select a room number.');
        return;
      }
    }

    if (_mobileController.text.trim().isEmpty) {
      _showSnack('Please enter mobile number.');
      return;
    }

    if (_emobileController.text.trim().isEmpty) {
      _showSnack('Please enter emergency mobile number.');
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      _showSnack('Please enter name.');
      return;
    }

    // Validation for multiple images
    if (_aadharImagePaths.isEmpty) {
      _showSnack('Please upload at least one Aadhar Card image.');
      return;
    }

    if (_panImagePaths.isEmpty) {
      _showSnack('Please upload at least one PAN Card image.');
      return;
    }

    if (_profileImagePath == null) {
      _showSnack('Please take your Profile Photo (Selfie).');
      return;
    }

    final roomNumber = _isManualEntry
        ? _roomNoController.text.trim()
        : _selectedRoomNumber!;

    final roomType = _isManualEntry ? '' : (_selectedRoomType ?? '');
    final shareType = _isManualEntry ? '' : (_selectedShareType ?? '');

    // Create request with multiple images and booking details
    final request = HostelBookingRequestModel(
      name: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: '',
      roomNo: roomNumber,
      roomType: roomType,
      shareType: shareType,
      bookingType: '', // Empty as not needed
      totalAmount: 0, // Not needed
      aadharCardImage: _aadharImagePaths,
      panCardImage: _panImagePaths,
      profileImage: _profileImagePath!,
      emergencyNumber: _emobileController.text.trim(),
    );

    final provider = context.read<HostelBookingProvider>();
    final success = await provider.submitBooking(
      bookingId: widget.bookingId,
      request: request,
    );

    if (!mounted) return;

    if (success) {
      _showSuccessDialog();
    } else {
      _showSnack(provider.errorMessage ?? 'Booking failed. Please try again.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.red,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Submitted!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your booking request has been submitted successfully. You will be notified once confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HostelBookingProvider(),
      child: Builder(builder: (ctx) => _buildScaffold(ctx)),
    );
  }

  Widget _buildScaffold(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Enter ',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _buildSectionLabel('Profile Photo (Selfie)'),
            const SizedBox(height: 10),
            _buildProfilePicker(),
            const SizedBox(height: 24),
            _buildSectionLabel('Personal Information'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _mobileController,
              label: 'Mobile Number',
              hint: '10-digit mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Mobile is required';
                if (v.trim().length != 10)
                  return 'Enter a valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _emobileController,
              label: 'Emergency Number',
              hint: '10-digit mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Mobile is required';
                if (v.trim().length != 10)
                  return 'Enter a valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Room Details'),
            const SizedBox(height: 12),
            _buildRoomDetailsSection(),
            const SizedBox(height: 24),
            _buildSectionLabel('Upload Documents'),
            const SizedBox(height: 12),
            _buildMultiImageUploadTile(
              label: 'Aadhar Card',
              subtitle: 'Upload front and back sides (Max 2 images)',
              icon: Icons.badge_outlined,
              imagePaths: _aadharImagePaths,
              maxImages: _maxImagesPerDocument,
              onAddImage: (sideIndex) =>
                  _showImageSourceDialog('aadhar', sideIndex),
              onRemoveImage: (index) => _removeDocumentImage('aadhar', index),
            ),
            const SizedBox(height: 12),
            _buildMultiImageUploadTile(
              label: 'Photo ID Card',
              subtitle: 'Upload front and back sides (Max 2 images)',
              icon: Icons.credit_card_outlined,
              imagePaths: _panImagePaths,
              maxImages: _maxImagesPerDocument,
              onAddImage: (sideIndex) =>
                  _showImageSourceDialog('pan', sideIndex),
              onRemoveImage: (index) => _removeDocumentImage('pan', index),
            ),
            const SizedBox(height: 32),
            Consumer<HostelBookingProvider>(
              builder: (_, provider, __) => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _onProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.red.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomDetailsSection() {
    if (_isLoadingRoomNumbers) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading room options...'),
          ],
        ),
      );
    }

    if (_sharingOptions.isNotEmpty && !_isManualEntry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Type Dropdown (AC/Non-AC)
          _buildDropdown(
            label: 'Room Type',
            hint: 'Select AC or Non-AC',
            icon: Icons.ac_unit_outlined,
            value: _selectedRoomType,
            items: _roomTypes,
            onChanged: _onRoomTypeChanged,
            validator: (v) => v == null ? 'Please select room type' : null,
          ),
          const SizedBox(height: 14),

          // Share Type Dropdown (1 Share, 2 Share, etc.)
          if (_selectedRoomType != null)
            _buildDropdown(
              label: 'Share Type',
              hint: 'Select sharing type',
              icon: Icons.people_outline,
              value: _selectedShareType,
              items: _shareTypes,
              onChanged: _onShareTypeChanged,
              validator: (v) => v == null ? 'Please select share type' : null,
            ),

          if (_selectedShareType != null) const SizedBox(height: 14),

          // Room Number Dropdown
          if (_selectedShareType != null && _roomNumbers.isNotEmpty)
            _buildDropdown(
              label: 'Room Number',
              hint: 'Select room number',
              icon: Icons.door_back_door_outlined,
              value: _selectedRoomNumber,
              items: _roomNumbers,
              onChanged: (val) => setState(() => _selectedRoomNumber = val),
              validator: (v) => v == null ? 'Please select room number' : null,
            ),
        ],
      );
    }

    // Manual entry mode
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _roomNoController,
          label: 'Room Number',
          hint: 'e.g., 101, G1, 202',
          icon: Icons.door_back_door_outlined,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Room number is required' : null,
        ),
        if (_sharingOptions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Want to select from available rooms?',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isManualEntry = false;
                    _roomNoController.clear();
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Select from list',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
        if (_roomNumbersError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _roomNumbersError!,
              style: const TextStyle(fontSize: 11, color: Colors.orange),
            ),
          ),
      ],
    );
  }

  Widget _buildMultiImageUploadTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required List<String> imagePaths,
    required int maxImages,
    required void Function(int sideIndex) onAddImage,
    required void Function(int index) onRemoveImage,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: imagePaths.isNotEmpty
            ? const Color(0xFFFFF3F3)
            : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: imagePaths.isNotEmpty
              ? Colors.red.withOpacity(0.5)
              : const Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: imagePaths.isNotEmpty ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (imagePaths.length < maxImages)
                IconButton(
                  onPressed: () => onAddImage(imagePaths.length),
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Colors.red,
                    size: 24,
                  ),
                  tooltip: 'Add image',
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (imagePaths.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePaths[index]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => onRemoveImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          index == 0 ? 'Front' : 'Back',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          if (imagePaths.isEmpty)
            GestureDetector(
              onTap: () => onAddImage(0),
              child: Center(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, color: Colors.red, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to upload ${label.toLowerCase()}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (imagePaths.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${imagePaths.length}/$maxImages images uploaded',
                style: TextStyle(
                  fontSize: 11,
                  color: imagePaths.length == maxImages
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildProfilePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickProfileImage,
        child: Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF5F5F5),
                border: Border.all(
                  color: Colors.red.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: _profileImagePath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_profileImagePath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person, size: 44, color: Colors.grey),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.red, size: 20),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.red, size: 20),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
  }
}

// Model class for sharing options
class SharingOption {
  final String type;
  final String shareType;
  final int monthlyPrice;
  final int dailyPrice;
  final List<String> roomNumbers;

  SharingOption({
    required this.type,
    required this.shareType,
    required this.monthlyPrice,
    required this.dailyPrice,
    required this.roomNumbers,
  });

  factory SharingOption.fromJson(Map<String, dynamic> json) {
    return SharingOption(
      type: json['type'] ?? '',
      shareType: json['shareType'] ?? '',
      monthlyPrice: json['monthlyPrice'] ?? 0,
      dailyPrice: json['dailyPrice'] ?? 0,
      roomNumbers: List<String>.from(json['roomNumbers'] ?? []),
    );
  }
}
