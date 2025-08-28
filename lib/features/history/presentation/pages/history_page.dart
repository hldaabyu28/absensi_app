// features/history/presentation/pages/history_page.dart
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';
import 'package:absensi_app/features/auth/presentation/providers/authenticate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/history_provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  void _loadHistory() {
    final authProvider = Provider.of<AuthenticateProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    
    final user = authProvider.user;
    if (user != null) {
      historyProvider.loadAttendanceHistory(user.uid);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _selectedStartDate ?? DateTime.now() : _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  void _applyDateFilter() {
    final authProvider = Provider.of<AuthenticateProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    
    final user = authProvider.user;
    if (user != null && _selectedStartDate != null && _selectedEndDate != null) {
      // Set end date to end of day
      final endDate = DateTime(
        _selectedEndDate!.year,
        _selectedEndDate!.month,
        _selectedEndDate!.day,
        23, 59, 59
      );
      
      historyProvider.loadAttendanceHistoryByDateRange(
        user.uid, 
        _selectedStartDate!, 
        endDate
      );
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedStartDate = null;
      _selectedEndDate = null;
    });
    
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    historyProvider.clearFilters();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticateProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Absensi'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text(
                          _selectedStartDate != null
                              ? DateFormat('dd/MM/yyyy').format(_selectedStartDate!)
                              : 'Pilih Tanggal Mulai',
                        ),
                      ),
                    ),
                    Text(' hingga '),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text(
                          _selectedEndDate != null
                              ? DateFormat('dd/MM/yyyy').format(_selectedEndDate!)
                              : 'Pilih Tanggal Akhir',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyDateFilter,
                        child: Text('Terapkan Filter'),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _clearFilters,
                      child: Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Error Message
          if (historyProvider.errorMessage.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                historyProvider.errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          // Loading Indicator
          if (historyProvider.isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Empty State
          if (!historyProvider.isLoading && historyProvider.attendanceHistory.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada riwayat absensi',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    if (_selectedStartDate != null || _selectedEndDate != null)
                      TextButton(
                        onPressed: _clearFilters,
                        child: Text('Hapus filter'),
                      ),
                  ],
                ),
              ),
            ),

          // Attendance List
          if (!historyProvider.isLoading && historyProvider.attendanceHistory.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: historyProvider.attendanceHistory.length,
                itemBuilder: (context, index) {
                  final attendance = historyProvider.attendanceHistory[index];
                  return _AttendanceListItem(attendance: attendance);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _AttendanceListItem extends StatelessWidget {
  final AttendanceEntity attendance;

  const _AttendanceListItem({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(attendance.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(DateFormat('dd MMMM yyyy').format(attendance.dateTime)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('HH:mm:ss').format(attendance.dateTime)),
            Text(
              attendance.address.length > 30
                  ? '${attendance.address.substring(0, 30)}...'
                  : attendance.address,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: attendance.isLocationValid ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            attendance.isLocationValid ? 'Valid' : 'Tidak Valid',
            style: TextStyle(
              color: attendance.isLocationValid ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          _showAttendanceDetail(context, attendance);
        },
      ),
    );
  }

  void _showAttendanceDetail(BuildContext context, AttendanceEntity attendance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Absensi'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(attendance.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Tanggal: ${DateFormat('dd MMMM yyyy').format(attendance.dateTime)}'),
              Text('Waktu: ${DateFormat('HH:mm:ss').format(attendance.dateTime)}'),
              SizedBox(height: 8),
              Text('Lokasi: ${attendance.address}'),
              Text('Koordinat: ${attendance.latitude.toStringAsFixed(6)}, ${attendance.longitude.toStringAsFixed(6)}'),
              SizedBox(height: 8),
              Text(
                'Status: ${attendance.isLocationValid ? 'Valid' : 'Tidak Valid'}',
                style: TextStyle(
                  color: attendance.isLocationValid ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}