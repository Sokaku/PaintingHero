import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';

class MetroLogo extends StatelessWidget {
  final double size;
  
  const MetroLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The Madrid Diamond (Red border, White background)
          // Increased size to 0.85 to give more room for text
          Transform.rotate(
            angle: 0.785398, // 45 degrees
            child: Container(
              width: size * 0.85, 
              height: size * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE30613), // Madrid Metro Red
                  width: size * 0.08, // Proportional thicker border
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(6, 6),
                  ),
                ],
              ),
            ),
          ),
          // The Text inside
          Padding(
            padding: EdgeInsets.all(size * 0.15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'PUSSY',
                    style: TextStyle(
                      color: const Color(0xFF003D8E), // Madrid Metro Blue
                      fontSize: size * 0.14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'STATION',
                    style: TextStyle(
                      color: const Color(0xFF003D8E), // Madrid Metro Blue
                      fontSize: size * 0.14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
