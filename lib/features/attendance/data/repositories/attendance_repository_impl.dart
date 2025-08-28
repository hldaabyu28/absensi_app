// features/attendance/data/repositories/attendance_repository_impl.dart
import 'package:absensi_app/core/utils/cloudinary_service.dart';
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';
import 'package:absensi_app/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;

  AttendanceRepositoryImpl(this._firestore, this._cloudinaryService);

  @override
  Future<AttendanceEntity> recordAttendance(
    String userId,
    double latitude,
    double longitude,
    String address,
    bool isLocationValid,
    String imagePath,
  ) async {
    try {
      final uploadedImageUrl = await _cloudinaryService.uploadImage(imagePath);
      
      final attendanceData = {
        'userId': userId,
        'dateTime': Timestamp.now(),
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'isLocationValid': isLocationValid,
        'imageUrl': uploadedImageUrl,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()), // Tambah field date untuk query
      };
      
      final docRef = await _firestore.collection('attendances').add(attendanceData);
      
      return AttendanceEntity(
        id: docRef.id,
        userId: userId,
        dateTime: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        address: address,
        isLocationValid: isLocationValid,
        imageUrl: uploadedImageUrl,
      );
    } catch (e) {
      throw Exception('Failed to record attendance: $e');
    }
  }

  @override
  Future<bool> hasAttendedToday(String userId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    final snapshot = await _firestore
        .collection('attendances')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: today) // Gunakan field date instead of dateTime range
        .limit(1)
        .get();
    
    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<AttendanceEntity?> getTodayAttendance(String userId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    final snapshot = await _firestore
        .collection('attendances')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: today) // Gunakan field date instead of dateTime range
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) return null;
    
    final doc = snapshot.docs.first;
    final data = doc.data() as Map<String, dynamic>;
    
    return AttendanceEntity(
      id: doc.id,
      userId: data['userId'] as String,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
      address: data['address'] as String,
      isLocationValid: data['isLocationValid'] as bool,
      imageUrl: data['imageUrl'] as String,
    );
  }
}