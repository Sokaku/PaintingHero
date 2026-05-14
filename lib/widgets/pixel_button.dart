import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';

class PixelButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;

  const PixelButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = PixelColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: onPressed == null ? Colors.grey : color,
          border: Border.all(color: PixelColors.border, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
