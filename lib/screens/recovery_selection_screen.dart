import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/pixel_colors.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_card.dart';
import 'package:intl/intl.dart';

import '../services/attendance_service.dart';

class RecoverySelectionScreen extends StatefulWidget {
  final UserModel user;
  final DateTime absenceDate;

  const RecoverySelectionScreen({
    super.key,
    required this.user,
    required this.absenceDate,
  });

  @override
  State<RecoverySelectionScreen> createState() => _RecoverySelectionScreenState();
}

class _RecoverySelectionScreenState extends State<RecoverySelectionScreen> {
  DateTime? _selectedDate;
  final AttendanceService _attendanceService = AttendanceService();
  final Map<DateTime, int> _freeSlotsMap = {};

  @override
  void initState() {
    super.initState();
    _loadAllFreeSlots();
  }

  Future<void> _loadAllFreeSlots() async {
    // Load slots for the next 30 days
    for (int i = 1; i <= 30; i++) {
      final date = DateTime.now().add(Duration(days: i));
      if (date.weekday <= 5 && !widget.user.diasClase.contains(date.weekday)) {
        final slots = await _attendanceService.getFreeSlots(date);
        if (mounted) {
          setState(() {
            _freeSlotsMap[DateTime(date.year, date.month, date.day)] = slots;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PixelColors.background,
      appBar: AppBar(
        title: const Text('BUSCAR HUECO REAL', style: TextStyle(fontSize: 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PixelCard(
              title: 'AUSENCIA',
              child: Text(
                DateFormat('EEEE d MMMM', 'es_ES').format(widget.absenceDate).toUpperCase(),
                style: const TextStyle(color: PixelColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 30,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index + 1));
                final normalizedDate = DateTime(date.year, date.month, date.day);
                
                if (date.weekday > 5 || widget.user.diasClase.contains(date.weekday)) return const SizedBox.shrink();
                
                final slots = _freeSlotsMap[normalizedDate];
                if (slots == null) return const SizedBox(height: 50, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
                if (slots <= 0) return const SizedBox.shrink(); // Lleno

                final isSelected = _selectedDate?.day == date.day && _selectedDate?.month == date.month;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? PixelColors.primary.withOpacity(0.2) : PixelColors.surface,
                      border: Border.all(
                        color: isSelected ? PixelColors.primary : Colors.white10,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE d MMMM', 'es_ES').format(date).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? PixelColors.primary : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('$slots PLAZAS LIBRES', 
                                style: TextStyle(fontSize: 8, color: slots > 3 ? Colors.greenAccent : Colors.orangeAccent)),
                            ],
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle, color: PixelColors.primary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PixelButton(
              text: 'CONFIRMAR CAMBIO',
              onPressed: _selectedDate == null ? null : () => Navigator.pop(context, _selectedDate),
            ),
          ),
        ],
      ),
    );
  }
}
