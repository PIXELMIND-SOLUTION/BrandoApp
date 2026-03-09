// lib/providers/profile_provider.dart

import 'dart:io';
import 'package:brando_app/helper/shared_preference.dart';
import 'package:brando_app/models/profile_model.dart';
import 'package:brando_app/services/auth/profile_service.dart';
import 'package:flutter/foundation.dart';


enum ProfileStatus { idle, loading, success, error }

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService.instance;

  ProfileStatus _status = ProfileStatus.idle;
  UserProfileModel? _profile;
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────

  ProfileStatus get status => _status;
  UserProfileModel? get profile => _profile;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ProfileStatus.loading;

  // ─── Fetch Profile ────────────────────────────────────────────────────────

  Future<void> fetchProfile() async {
    final userId = AppPreferences.getUserId();
    if (userId == null || userId.isEmpty) {
      _setError('User ID not found. Please log in again.');
      return;
    }

    _setLoading();
    try {
      _profile = await _service.getUserProfile(userId);
      _setSuccess();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ─── Update Profile ───────────────────────────────────────────────────────

  Future<bool> updateProfile({String? name, File? profileImage}) async {
    final userId = AppPreferences.getUserId();
    if (userId == null || userId.isEmpty) {
      _setError('User ID not found. Please log in again.');
      return false;
    }

    // Validate: at least one field must be provided
    if ((name == null || name.trim().isEmpty) && profileImage == null) {
      _setError('Please provide a name or profile image to update.');
      return false;
    }

    _setLoading();
    try {
      _profile = await _service.updateProfile(
        userId: userId,
        name: name?.trim(),
        profileImage: profileImage,
      );
      _setSuccess();
      return true;
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  // ─── Clear / Reset ────────────────────────────────────────────────────────

  void clearError() {
    _errorMessage = null;
    _status = ProfileStatus.idle;
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    _status = ProfileStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────

  void _setLoading() {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = ProfileStatus.success;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = ProfileStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}