import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';
import '../models/user_model.dart';

class PixelCalendar extends StatefulWidget {
  final UserModel user;
  final Function(int fromDay, int toDay) onClassMoved;

  const PixelCalendar({
    super.key,
    required this.user,
    required this.onClassMoved,
  });

  @override
  State<PixelCalendar> createState() => _PixelCalendarState();
}

class _PixelCalendarState extends State<PixelCalendar> {
  final List<String> _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar Header
        Row(
          children: _days.map((day) => Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: PixelColors.secondary,
                border: Border.all(color: PixelColors.border, width: 2),
              ),
              child: Text(day, style: const TextStyle(fontSize: 10)),
            ),
          )).toList(),
        ),
        // Calendar Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.8,
          ),
          itemCount: 7, // Simple weekly view for now
          itemBuilder: (context, index) {
            final dayNumber = index + 1;
            final isClassDay = widget.user.diasClase.contains(dayNumber);

            return DragTarget<int>(
              onWillAccept: (data) => data != dayNumber,
              onAccept: (data) {
                widget.onClassMoved(data, dayNumber);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty ? PixelColors.accent : PixelColors.surface,
                    border: Border.all(color: PixelColors.border, width: 2),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Text('$dayNumber', style: const TextStyle(fontSize: 8)),
                      ),
                      if (isClassDay)
                        Center(
                          child: Draggable<int>(
                            data: dayNumber,
                            feedback: _buildClassItem(true),
                            childWhenDragging: Opacity(
                              opacity: 0.5,
                              child: _buildClassItem(false),
                            ),
                            child: _buildClassItem(false),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildClassItem(bool isFeedback) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: PixelColors.primary,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.brush, size: 20, color: Colors.white),
      ),
    );
  }
}
