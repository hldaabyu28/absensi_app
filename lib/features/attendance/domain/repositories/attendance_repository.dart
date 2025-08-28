// features/attendance/domain/repositories/attendance_repository.dart
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity> recordAttendance(
    String userId,
    double latitude,
    double longitude,
    String address,
    bool isLocationValid,
    String imageUrl,
  );

  Future<bool> hasAttendedToday(String userId);
  Future<AttendanceEntity?> getTodayAttendance(String userId);
}
