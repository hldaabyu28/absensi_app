// features/history/presentation/widgets/history_empty_state.dart
import 'package:flutter/material.dart';

class HistoryEmptyState extends StatelessWidget {
  final bool hasActiveFilter;
  final VoidCallback onClearFilter;

  const HistoryEmptyState({
    Key? key,
    required this.hasActiveFilter,
    required this.onClearFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hasActiveFilter ? Icons.search_off_rounded : Icons.history_rounded,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 24),
            
            // Title
            Text(
              hasActiveFilter 
                  ? 'Tidak Ada Data' 
                  : 'Belum Ada Riwayat Absensi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            
            SizedBox(height: 8),
            
            // Description
            Text(
              hasActiveFilter
                  ? 'Tidak ada riwayat absensi yang ditemukan\nuntuk rentang tanggal yang dipilih.'
                  : 'Mulai absensi untuk melihat\nriwayat absensi Anda di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Action Button
            if (hasActiveFilter)
              ElevatedButton.icon(
                onPressed: onClearFilter,
                icon: Icon(Icons.clear_rounded, size: 18),
                label: Text('Hapus Filter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Colors.blue[600],
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Lakukan absensi pertama Anda!',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}