// features/history/presentation/widgets/history_list_view.dart
import 'package:absensi_app/features/attendance/domain/entities/attendance_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'attendance_list_item.dart';

class HistoryListView extends StatelessWidget {
  final List<AttendanceEntity> attendanceHistory;

  const HistoryListView({Key? key, required this.attendanceHistory})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group attendance by month
    final groupedHistory = _groupByMonth(attendanceHistory);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: groupedHistory.length,
      itemBuilder: (context, index) {
        final monthData = groupedHistory[index];
        final monthKey = monthData['month'] as String;
        final attendanceList =
            monthData['attendances'] as List<AttendanceEntity>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Header
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.blue[600],
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    monthKey,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${attendanceList.length} hari',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Attendance Items for this month
            ...attendanceList
                .map((attendance) => AttendanceListItem(attendance: attendance))
                .toList(),

            SizedBox(height: 8),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _groupByMonth(
    List<AttendanceEntity> attendanceList,
  ) {
    final Map<String, List<AttendanceEntity>> grouped = {};

    for (final attendance in attendanceList) {
      final monthKey = DateFormat(
        'MMMM yyyy',
        'id_ID',
      ).format(attendance.dateTime);
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(attendance);
    }

    // Convert to list and sort by date (newest first)
    final result =
        grouped.entries.map((entry) {
          // Sort attendances within each month by date (newest first)
          entry.value.sort((a, b) => b.dateTime.compareTo(a.dateTime));

          return {
            'month': entry.key,
            'attendances': entry.value,
            'firstDate': entry.value.first.dateTime,
          };
        }).toList();

    // Sort months by date (newest first)
    result.sort(
      (a, b) =>
          (b['firstDate'] as DateTime).compareTo(a['firstDate'] as DateTime),
    );

    return result;
  }
}
