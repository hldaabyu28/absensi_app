// features/attendance/domain/entities/attendance_entity.dart
class AttendanceEntity {
  final String id;
  final String userId;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final String address;
  final bool isLocationValid;
  final String imageUrl;

  AttendanceEntity({
    required this.id,
    required this.userId,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isLocationValid,
    required this.imageUrl,
  });
}
