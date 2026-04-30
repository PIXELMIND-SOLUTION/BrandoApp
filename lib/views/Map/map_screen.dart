import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final double? hostelLatitude;
  final double? hostelLongitude;
  final String? hostelName;
  final String? hostelAddress;

  const MapScreen({
    super.key,
    this.hostelLatitude,
    this.hostelLongitude,
    this.hostelName,
    this.hostelAddress,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  LatLng? _hostelLocation;
  bool _isLoading = true;
  String? _errorMessage;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    // Set hostel marker if coordinates were passed in
    if (widget.hostelLatitude != null && widget.hostelLongitude != null) {
      _hostelLocation = LatLng(widget.hostelLatitude!, widget.hostelLongitude!);
      _markers.add(
        Marker(
          markerId: const MarkerId('hostel'),
          position: _hostelLocation!,
          infoWindow: InfoWindow(
            title: widget.hostelName ?? 'Hostel',
            snippet: widget.hostelAddress ?? '',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Fetch current user location
    await _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Location permission denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location permission permanently denied.';
        });
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId('user'),
            position: _userLocation!,
            infoWindow: const InfoWindow(title: 'You are here'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
        _isLoading = false;
      });

      // Animate camera to hostel if available, else to user
      final target = _hostelLocation ?? _userLocation!;
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(target, 14),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not fetch location: $e';
      });
    }
  }

   Future<void> _openDirections() async {
    if (_hostelLocation == null) return;
    final lat = _hostelLocation!.latitude;
    final lng = _hostelLocation!.longitude;
    final label = Uri.encodeComponent(widget.hostelName ?? 'Hostel');
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$label',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  LatLng get _initialCameraTarget =>
      _hostelLocation ??
      _userLocation ??
      const LatLng(20.5937, 78.9629); // centre of India as fallback

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 16, color: Colors.black87),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hostelName ?? 'Location',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (widget.hostelAddress != null)
              Text(
                widget.hostelAddress!,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          if (_hostelLocation != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: _openDirections,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.directions, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Directions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // ── Google Map ────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialCameraTarget,
              zoom: 13,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_isLoading) {
                final target = _hostelLocation ?? _userLocation;
                if (target != null) {
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(target, 14),
                  );
                }
              }
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ── Loading overlay ───────────────────────────────────────────────
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),

          // ── Error banner ──────────────────────────────────────────────────
          if (_errorMessage != null)
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.red.shade400, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── My-location FAB ───────────────────────────────────────────────
          Positioned(
            bottom: _hostelLocation != null ? 90 : 24,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'myLocation',
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              // onTap: () {
              //   if (_userLocation != null) {
              //     _mapController?.animateCamera(
              //       CameraUpdate.newLatLngZoom(_userLocation!, 15),
              //     );
              //   }
              // },
              onPressed: () {
                if (_userLocation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_userLocation!, 15),
                  );
                }
              },
              child: const Icon(Icons.my_location, color: Colors.red, size: 20),
            ),
          ),

          // ── Bottom hostel info card ────────────────────────────────────────
          if (_hostelLocation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.apartment,
                          color: Colors.red, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.hostelName ?? 'Hostel',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (widget.hostelAddress != null)
                            Text(
                              widget.hostelAddress!,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _openDirections,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.directions,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}