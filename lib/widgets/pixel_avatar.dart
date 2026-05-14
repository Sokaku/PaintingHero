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
    final int head = config['head'] ?? 1;
    final int torso = config['torso'] ?? 1;
    final int legs = config['legs'] ?? 1;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: PixelColors.primary.withOpacity(0.5), width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final partSize = constraints.maxHeight * 0.28; // Reducimos ligeramente el tamaño
          final spacing = constraints.maxHeight * 0.05; // Espaciado relativo
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPart('head', head, partSize),
              SizedBox(height: spacing),
              _buildPart('torso', torso, partSize),
              SizedBox(height: spacing),
              _buildPart('legs', legs, partSize),
            ],
          );
        }
      ),
    );
  }

  Widget _buildPart(String type, int id, double partSize) {
    return Container(
      width: partSize,
      height: partSize,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Image.asset(
        'assets/images/parts/${type}_$id.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            type == 'head' ? Icons.face : (type == 'torso' ? Icons.accessibility_new : Icons.airline_stops),
            color: PixelColors.primary,
            size: partSize * 0.7,
          );
        },
      ),
    );
  }
}
