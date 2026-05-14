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

  void _nextHead() {
    setState(() {
      int current = _config['head'] ?? 1;
      _config['head'] = current < 4 ? current + 1 : 1;
    });
  }

  void _prevHead() {
    setState(() {
      int current = _config['head'] ?? 1;
      _config['head'] = current > 1 ? current - 1 : 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: PixelColors.background,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: PixelColors.primary, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ELIGE TU IDENTIDAD', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: PixelColors.primary)),
            const SizedBox(height: 24),
            
            // Selector de cabeza con flechas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: PixelColors.primary, size: 40),
                  onPressed: _prevHead,
                ),
                const SizedBox(width: 16),
                PixelAvatar(config: _config, size: 120),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: PixelColors.primary, size: 40),
                  onPressed: _nextHead,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
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
                  child: const Text('GUARDAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
