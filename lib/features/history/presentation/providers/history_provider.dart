// features/history/presentation/providers/history_provider.dart
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/history_repository.dart';

class HistoryProvider with ChangeNotifier {
  final HistoryRepository _historyRepository;

  HistoryProvider(this._historyRepository);

  bool _isLoading = false;
  List<AttendanceEntity> _attendanceHistory = [];
  String _errorMessage = '';
  DateTime? _startDate;
  DateTime? _endDate;

  bool get isLoading => _isLoading;
  List<AttendanceEntity> get attendanceHistory => _attendanceHistory;
  String get errorMessage => _errorMessage;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  Future<void> loadAttendanceHistory(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _attendanceHistory = await _historyRepository.getAttendanceHistory(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat riwayat absensi: $e';
      notifyListeners();
      print('Error loading attendance history: $e');
    }
  }

  Future<void> loadAttendanceHistoryByDateRange(
      String userId, DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _errorMessage = '';
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();

    try {
      _attendanceHistory = await _historyRepository.getAttendanceHistoryByDateRange(
          userId, startDate, endDate);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat riwayat absensi: $e';
      notifyListeners();
      print('Error loading attendance history by date range: $e');
    }
  }

  void clearFilters() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}