import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';

class PixelAvatar extends StatelessWidget {
  final Map<String, dynamic> config;
  final double size;

  const PixelAvatar({
    super.key,
    required this.config,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final int headId = config['head'] ?? 1;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: PixelColors.primary, width: 2),
      ),
      child: Image.asset(
        'assets/images/parts/head_${headId}_v2.png',
        fit: BoxFit.cover, // Zoom total
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(Icons.face, color: PixelColors.primary.withOpacity(0.5), size: size * 0.5),
        ),
      ),
    );
  }
}
