import 'package:flutter/material.dart';
import '../theme/pixel_colors.dart';
import 'pixel_avatar.dart';

class PixelAvatarEditor extends StatefulWidget {
  final Map<String, dynamic> initialConfig;
  final Function(Map<String, dynamic>) onSave;

  const PixelAvatarEditor({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<PixelAvatarEditor> createState() => _PixelAvatarEditorState();
}

class _PixelAvatarEditorState extends State<PixelAvatarEditor> {
  late Map<String, dynamic> _config;

  @override
  void initState() {
    super.initState();
    _config = Map.from(widget.initialConfig);
  }

  void _nextPart(String key) {
    setState(() {
      int current = _config[key] ?? 1;
      _config[key] = current < 4 ? current + 1 : 1;
    });
  }

  void _prevPart(String key) {
    setState(() {
      int current = _config[key] ?? 1;
      _config[key] = current > 1 ? current - 1 : 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: PixelColors.background,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: PixelColors.primary, width: 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('VESTIDOR DE HÉROES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: PixelColors.primary)),
            const SizedBox(height: 32),
            
            // EL PERSONAJE CON SUS CONTROLES
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                color: Colors.black26,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Vista previa con el nuevo layout de columna
                  PixelAvatar(config: _config, size: 220),
                  
                  // Controles alineados con las 3 partes
                  Positioned(
                    top: 25, // Alineado con Cabeza
                    left: 0, right: 0,
                    child: _buildArrowRow('head'),
                  ),
                  Positioned(
                    top: 95, // Alineado con Tronco
                    left: 0, right: 0,
                    child: _buildArrowRow('torso'),
                  ),
                  Positioned(
                    top: 165, // Alineado con Piernas
                    left: 0, right: 0,
                    child: _buildArrowRow('legs'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: PixelColors.primary),
                  onPressed: () {
                    widget.onSave(_config);
                    Navigator.pop(context);
                  },
                  child: const Text('GUARDAR ESTILO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrowRow(String partKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildArrowButton(Icons.chevron_left, () => _prevPart(partKey)),
        _buildArrowButton(Icons.chevron_right, () => _nextPart(partKey)),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: PixelColors.primary,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), offset: const Offset(2, 2)),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }
}
