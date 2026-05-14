import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart';

class PixelCalendar extends StatefulWidget {
  final UserModel user;
  final Function(DateTime fromDate, DateTime toDate) onClassMoved;

  const PixelCalendar({
    super.key,
    required this.user,
    required this.onClassMoved,
  });

  @override
  State<PixelCalendar> createState() => _PixelCalendarState();
}

class _PixelCalendarState extends State<PixelCalendar> {
  final List<String> _weekDays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  late DateTime _currentMonth;
  late DateTime _nextMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    _nextMonth = DateTime(now.year, now.month + 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMonthView(_currentMonth),
        const SizedBox(height: 32),
        _buildMonthView(_nextMonth),
      ],
    );
  }

  Widget _buildMonthView(DateTime month) {
    final monthName = DateFormat('MMMM yyyy', 'es_ES').format(month).toUpperCase();
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOffset = (DateTime(month.year, month.month, 1).weekday - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            monthName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: PixelColors.primary,
              letterSpacing: 2,
            ),
          ),
        ),
        // Header Días Semana
        Row(
          children: _weekDays.map((day) => Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(day, style: const TextStyle(fontSize: 10, color: Colors.white70)),
            ),
          )).toList(),
        ),
        const SizedBox(height: 8),
        // Grid de Días
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: daysInMonth + firstDayOffset,
          itemBuilder: (context, index) {
            if (index < firstDayOffset) return const SizedBox.shrink();

            final day = index - firstDayOffset + 1;
            final date = DateTime(month.year, month.month, day);
            
            // Mock de plazas: Supongamos que hay un número random de ocupados
            // En un caso real esto vendría de Supabase
            final occupiedSlots = (day * 3) % 11; 
            final freeSlots = 10 - occupiedSlots;
            
            final isStudentClassDay = widget.user.diasClase.contains(date.weekday);
            final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

            return _buildDayCell(date, freeSlots, isStudentClassDay, isPast);
          },
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime date, int freeSlots, bool isClassDay, bool isPast) {
    Color cellColor = PixelColors.surface;
    if (isClassDay) cellColor = PixelColors.background.withOpacity(0.5);
    
    return GestureDetector(
      onTap: (!isPast && freeSlots > 0 && !isClassDay) 
        ? () => widget.onClassMoved(DateTime.now(), date) 
        : null,
      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          border: Border.all(
            color: isClassDay ? PixelColors.primary : Colors.white12,
            width: isClassDay ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4,
              left: 4,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 10,
                  color: isPast ? Colors.white24 : Colors.white,
                  fontWeight: isClassDay ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (!isPast)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$freeSlots',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: freeSlots > 0 ? Colors.greenAccent : Colors.redAccent,
                        ),
                      ),
                      const Text('PLAZAS', style: TextStyle(fontSize: 6, color: Colors.white54)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
