import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';

class PixelCard extends StatelessWidget {
  final Widget child;
  final String? title;

  const PixelCard({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PixelColors.surface,
        border: Border.all(color: PixelColors.border, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                color: PixelColors.primary,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}
