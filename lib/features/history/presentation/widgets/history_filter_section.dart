// features/history/presentation/widgets/history_filter_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryFilterSection extends StatelessWidget {
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Function(DateTime?, DateTime?) onDateFilterApplied;
  final VoidCallback onFilterCleared;

  const HistoryFilterSection({
    Key? key,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onDateFilterApplied,
    required this.onFilterCleared,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? selectedStartDate ?? DateTime.now() 
          : selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      if (isStartDate) {
        onDateFilterApplied(picked, selectedEndDate);
      } else {
        onDateFilterApplied(selectedStartDate, picked);
      }
    }
  }

  void _applyFilter() {
    if (selectedStartDate != null && selectedEndDate != null) {
      onDateFilterApplied(selectedStartDate, selectedEndDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
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
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.filter_list_rounded,
                  color: Colors.blue[600],
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Filter Tanggal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Date Selection Row
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  context: context,
                  label: 'Tanggal Mulai',
                  date: selectedStartDate,
                  onTap: () => _selectDate(context, true),
                  icon: Icons.event_note_rounded,
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'hingga',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDateButton(
                  context: context,
                  label: 'Tanggal Akhir',
                  date: selectedEndDate,
                  onTap: () => _selectDate(context, false),
                  icon: Icons.event_rounded,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: selectedStartDate != null && selectedEndDate != null
                      ? _applyFilter
                      : null,
                  icon: Icon(Icons.search_rounded, size: 18),
                  label: Text('Terapkan Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: selectedStartDate != null || selectedEndDate != null
                    ? onFilterCleared
                    : null,
                icon: Icon(Icons.clear_rounded, size: 18),
                label: Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),

          // Active Filter Indicator
          if (selectedStartDate != null && selectedEndDate != null)
            Container(
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, 
                      color: Colors.green[600], size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Filter aktif: ${DateFormat('dd/MM/yyyy').format(selectedStartDate!)} - ${DateFormat('dd/MM/yyyy').format(selectedEndDate!)}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateButton({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: date != null ? Colors.blue[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: date != null ? Colors.blue[200]! : Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: date != null ? Colors.blue[600] : Colors.grey[500],
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              date != null 
                  ? DateFormat('dd/MM/yyyy').format(date)
                  : 'Pilih tanggal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: date != null ? Colors.blue[700] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}