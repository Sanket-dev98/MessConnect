import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/app_theme.dart';

class KhataScreen extends StatelessWidget {
  const KhataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('My Khata'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Summary
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryItem(label: 'Total Meals', value: '42', color: AppColors.navyPrimary),
                  Container(width: 1, height: 40, color: Colors.grey[200]),
                  _SummaryItem(label: 'Skipped', value: '08', color: Colors.red),
                  Container(width: 1, height: 40, color: Colors.grey[200]),
                  _SummaryItem(label: 'Savings', value: '₹320', color: Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Calendar Grid
            Text(
              'August 2026',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 31,
                itemBuilder: (context, index) {
                  int day = index + 1;
                  bool isAbsent = [5, 12, 13, 20].contains(day);
                  bool isToday = day == 14;
                  
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday 
                          ? AppColors.navyPrimary 
                          : isAbsent ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: isToday ? null : Border.all(
                        color: isAbsent ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isToday ? Colors.white : isAbsent ? Colors.red : Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Timeline
            Text(
              'Recent Attendance',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 16),
            _TimelineItem(
              date: '14 Aug',
              meal: 'Lunch',
              status: 'Consumed',
              time: '12:45 PM',
              isLast: false,
            ),
            _TimelineItem(
              date: '14 Aug',
              meal: 'Breakfast',
              status: 'Consumed',
              time: '08:30 AM',
              isLast: false,
            ),
            _TimelineItem(
              date: '13 Aug',
              meal: 'Dinner',
              status: 'Skipped',
              time: '--',
              isSkipped: true,
              isLast: false,
            ),
            _TimelineItem(
              date: '13 Aug',
              meal: 'Lunch',
              status: 'Consumed',
              time: '01:10 PM',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String date;
  final String meal;
  final String status;
  final String time;
  final bool isLast;
  final bool isSkipped;

  const _TimelineItem({
    required this.date,
    required this.meal,
    required this.status,
    required this.time,
    required this.isLast,
    this.isSkipped = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isSkipped ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: Colors.grey[200],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$date · $meal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              Text(
                status,
                style: TextStyle(
                  color: isSkipped ? Colors.red : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
