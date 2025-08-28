// features/attendance/presentation/providers/attendance_provider.dart
import 'dart:io';

import 'package:absensi_app/core/utils/camera_service.dart';
import 'package:absensi_app/core/utils/location_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/attendance_repository.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepository _attendanceRepository;
  final LocationService _locationService;
  final CameraService _cameraService;

  AttendanceProvider(
    this._attendanceRepository,
    this._locationService,
    this._cameraService,
  );

  bool _isLoading = false;
  bool _isLoadingLocation = false;
  Position? _currentPosition;
  String _currentAddress = 'Mendeteksi lokasi...';
  bool _isWithinRadius = false;
  XFile? _capturedImage;
  dynamic _todayAttendance;
  String _locationError = '';
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoadingLocation => _isLoadingLocation;
  Position? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  bool get isWithinRadius => _isWithinRadius;
  XFile? get capturedImage => _capturedImage;
  dynamic get todayAttendance => _todayAttendance;
  String get locationError => _locationError;

  Future<void> initialize() async {
    await checkLocation();
    await checkTodayAttendance();
  }

  Future<void> checkLocation() async {
    _isLoadingLocation = true;
    _locationError = '';
    notifyListeners();

    try {
      _currentPosition = await _locationService.getCurrentLocation();
      _currentAddress = await _locationService.getAddressFromLatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      // Check if within 100m radius of office
      const officeLatitude = -8.176523;
      const officeLongitude = 111.939464;

      final distance = _locationService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        officeLatitude,
        officeLongitude,
      );

      _isWithinRadius = distance <= 100;
      _isLoadingLocation = false;
      notifyListeners();
    } catch (e) {
      _isLoadingLocation = false;
      _locationError = 'Gagal mendapatkan lokasi: $e';
      _currentAddress = 'Tidak dapat mengakses lokasi';
      notifyListeners();
      print('Error getting location: $e');
    }
  }

  Future<void> refreshLocation() async {
    await checkLocation();
  }

  Future<void> takePicture() async {
    try {
      _capturedImage = await _cameraService.takePicture();
      notifyListeners();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  // features/attendance/presentation/providers/attendance_provider.dart
  Future<void> recordAttendance(String userId) async {
    if (!_isWithinRadius || _capturedImage == null) {
      throw Exception('Lokasi tidak valid atau foto belum diambil');
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Validasi file exists
      final imageFile = File(_capturedImage!.path);
      if (!await imageFile.exists()) {
        throw Exception('File gambar tidak ditemukan');
      }

      _todayAttendance = await _attendanceRepository.recordAttendance(
        userId,
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _currentAddress,
        _isWithinRadius,
        _capturedImage!.path,
      );

      _isLoading = false;
      _errorMessage = '';
      notifyListeners();

      // Show success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Absensi berhasil dicatat!'), backgroundColor: Colors.green),
      // );
      
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal mencatat absensi: $e';
      notifyListeners();

      // Show error message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      // );

      print('Error recording attendance: $e');
    }
  }

  Future<void> checkTodayAttendance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _todayAttendance = await _attendanceRepository.getTodayAttendance(user.uid);
    notifyListeners();
  }
}
