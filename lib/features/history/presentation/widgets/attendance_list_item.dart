// features/history/presentation/widgets/attendance_list_item.dart
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'attendance_detail_dialog.dart';

class AttendanceListItem extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceListItem({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.1),
        child: InkWell(
          onTap: () => _showAttendanceDetail(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Photo
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      attendance.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.grey[400],
                            size: 28,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue[400]!,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(attendance.dateTime),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 4),
                      
                      // Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.blue[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            DateFormat('HH:mm:ss').format(attendance.dateTime),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 6),
                      
                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Colors.orange[600],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              attendance.address.length > 40
                                  ? '${attendance.address.substring(0, 40)}...'
                                  : attendance.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 12),
                
                // Status Badge
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: attendance.isLocationValid 
                            ? Colors.green[50] 
                            : Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: attendance.isLocationValid 
                              ? Colors.green[200]! 
                              : Colors.red[200]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            attendance.isLocationValid 
                                ? Icons.check_circle_rounded 
                                : Icons.error_rounded,
                            color: attendance.isLocationValid 
                                ? Colors.green[600] 
                                : Colors.red[600],
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            attendance.isLocationValid ? 'Valid' : 'Invalid',
                            style: TextStyle(
                              color: attendance.isLocationValid 
                                  ? Colors.green[700] 
                                  : Colors.red[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAttendanceDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AttendanceDetailDialog(attendance: attendance),
    );
  }
}