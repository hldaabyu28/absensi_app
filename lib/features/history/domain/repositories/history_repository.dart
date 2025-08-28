// features/history/domain/repositories/history_repository.dart
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';

abstract class HistoryRepository {
  Future<List<AttendanceEntity>> getAttendanceHistory(String userId);
  Future<List<AttendanceEntity>> getAttendanceHistoryByDateRange(
      String userId, DateTime startDate, DateTime endDate);
}