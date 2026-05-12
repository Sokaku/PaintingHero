import 'package:flutter/material.dart';
import '../widgets/pixel_card.dart';
import '../widgets/pixel_button.dart';
import '../theme/pixel_colors.dart';
import '../models/user_model.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final List<UserModel> _students = [
    // Mock data
    UserModel(
      id: '1',
      nombre: 'Artorias',
      apellido1: 'Abysswalker',
      email: 'artorias@dungeon.com',
      fechaAlta: DateTime.now(),
      diasClase: [1, 3],
      rol: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOD MODE - ADMIN'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PixelCard(
              title: 'GLOBAL SETTINGS',
              child: Row(
                children: [
                  const Expanded(child: Text('DEFAULT RECOVERIES:', style: TextStyle(fontSize: 10))),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                      onChanged: (val) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('STUDENT LIST', style: TextStyle(fontSize: 16, color: PixelColors.primary)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final s = _students[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: PixelColors.surface,
                      border: Border.all(color: PixelColors.border, width: 2),
                    ),
                    child: ListTile(
                      title: Text(s.nombre.toUpperCase(), style: const TextStyle(fontSize: 12)),
                      subtitle: Text('DAYS: ${s.diasClase.join(", ")}', style: const TextStyle(fontSize: 10)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () {}),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            PixelButton(
              text: 'SUMMON NEW STUDENT',
              onPressed: () {
                // TODO: Open registration dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
