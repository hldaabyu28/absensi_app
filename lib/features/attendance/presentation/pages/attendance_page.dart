import 'dart:io';

import 'package:absensi_app/features/auth/presentation/providers/authenticate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/attendance_provider.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticateProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Absensi Karyawan', 
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () => attendanceProvider.refreshLocation(),
            tooltip: 'Refresh Lokasi',
          ),
          IconButton(
            icon: Icon(Icons.history_rounded),
            onPressed: () => Navigator.pushNamed(context, '/history'),
            tooltip: 'Riwayat Absensi',
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () => authProvider.logout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Card - User Info & Date
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.blue[600]),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              authProvider.user?.email ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        Icons.calendar_today_rounded,
                        'Tanggal',
                        DateFormat('dd/MM/yyyy').format(DateTime.now()),
                      ),
                      Container(width: 1, height: 40, color: Colors.white30),
                      _buildInfoItem(
                        Icons.access_time_rounded,
                        'Waktu',
                        DateFormat('HH:mm').format(DateTime.now()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),

            // Location Card
            _buildLocationCard(attendanceProvider),
            
            SizedBox(height: 20),

            // Status Card
            _buildStatusCard(attendanceProvider),
            
            SizedBox(height: 20),

            // Camera Card
            _buildCameraCard(attendanceProvider),
            
            SizedBox(height: 24),

            // Attendance Button
            _buildAttendanceButton(attendanceProvider, authProvider),
            
            SizedBox(height: 16),

            // Location Status
            _buildLocationStatus(attendanceProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(AttendanceProvider attendanceProvider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.location_on_rounded, 
                    color: Colors.green[600], size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Lokasi Anda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (attendanceProvider.isLoadingLocation)
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Mendeteksi lokasi...', 
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            )
          else ...[
            Text(
              attendanceProvider.currentAddress,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            if (attendanceProvider.currentPosition != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Koordinat: ${attendanceProvider.currentPosition!.latitude.toStringAsFixed(6)}, '
                  '${attendanceProvider.currentPosition!.longitude.toStringAsFixed(6)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ],
          if (attendanceProvider.locationError.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                attendanceProvider.locationError,
                style: TextStyle(fontSize: 12, color: Colors.red[600]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(AttendanceProvider attendanceProvider) {
    final isAttended = attendanceProvider.todayAttendance != null;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAttended ? Colors.green[50] : Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isAttended ? Icons.check_circle_rounded : Icons.pending_rounded,
              color: isAttended ? Colors.green[600] : Colors.orange[600],
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Absensi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                isAttended ? 'Sudah Absen' : 'Belum Absen',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isAttended ? Colors.green[600] : Colors.orange[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraCard(AttendanceProvider attendanceProvider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.camera_alt_rounded, 
                    color: Colors.purple[600], size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Foto Selfie',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          if (attendanceProvider.capturedImage != null) ...[
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(attendanceProvider.capturedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => attendanceProvider.takePicture(),
              icon: Icon(Icons.camera_alt_rounded),
              label: Text(attendanceProvider.capturedImage != null 
                  ? 'Ambil Ulang Foto' : 'Ambil Foto Selfie'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton(AttendanceProvider attendanceProvider, AuthenticateProvider authProvider) {
    final canAttend = attendanceProvider.isWithinRadius && 
                     attendanceProvider.capturedImage != null &&
                     attendanceProvider.todayAttendance == null &&
                     !attendanceProvider.isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canAttend
            ? () => attendanceProvider.recordAttendance(authProvider.user!.uid)
            : null,
        child: attendanceProvider.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint_rounded, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'ABSEN SEKARANG',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: canAttend ? Colors.green[600] : Colors.grey[400],
          foregroundColor: Colors.white,
          elevation: canAttend ? 4 : 0,
          shadowColor: Colors.green.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStatus(AttendanceProvider attendanceProvider) {
    if (attendanceProvider.currentPosition == null) return SizedBox();

    final isWithinRadius = attendanceProvider.isWithinRadius;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWithinRadius ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWithinRadius ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isWithinRadius ? Icons.check_circle_rounded : Icons.warning_rounded,
            color: isWithinRadius ? Colors.green[600] : Colors.orange[600],
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              isWithinRadius
                  ? 'Lokasi Anda valid (dalam radius 100m dari kantor)'
                  : 'Anda berada di luar radius 100m dari kantor',
              style: TextStyle(
                color: isWithinRadius ? Colors.green[700] : Colors.orange[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}