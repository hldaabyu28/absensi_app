// features/history/data/repositories/history_repository_impl.dart
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';
import 'package:absensi_app/features/history/domain/repositories/history_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final FirebaseFirestore _firestore;

  HistoryRepositoryImpl(this._firestore);

  @override
  Future<List<AttendanceEntity>> getAttendanceHistory(String userId) async {
    try {
      // Solusi: Query tanpa orderBy dulu, kemudian sort secara manual
      final snapshot = await _firestore
          .collection('attendances')
          .where('userId', isEqualTo: userId)
          .get();

      // Sort secara manual di client side
      final sortedDocs = snapshot.docs.toList()
        ..sort((a, b) {
          final aTime = (a.data()['dateTime'] as Timestamp).toDate();
          final bTime = (b.data()['dateTime'] as Timestamp).toDate();
          return bTime.compareTo(aTime); // Descending
        });

      return sortedDocs.map((doc) {
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
      }).toList();
    } catch (e) {
      print('Error getting attendance history: $e');
      throw Exception('Failed to get attendance history: $e');
    }
  }

  @override
  Future<List<AttendanceEntity>> getAttendanceHistoryByDateRange(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      // Untuk date range, kita perlu menggunakan field terpisah 'date'
      final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
      final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);
      
      final snapshot = await _firestore
          .collection('attendances')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDateStr)
          .where('date', isLessThanOrEqualTo: endDateStr)
          .get();

      // Sort secara manual
      final sortedDocs = snapshot.docs.toList()
        ..sort((a, b) {
          final aTime = (a.data()['dateTime'] as Timestamp).toDate();
          final bTime = (b.data()['dateTime'] as Timestamp).toDate();
          return bTime.compareTo(aTime); // Descending
        });

      return sortedDocs.map((doc) {
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
      }).toList();
    } catch (e) {
      print('Error getting attendance history by date range: $e');
      throw Exception('Failed to get attendance history by date range: $e');
    }
  }
}