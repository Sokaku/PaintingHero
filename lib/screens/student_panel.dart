import 'package:flutter/material.dart';
import '../widgets/pixel_calendar.dart';
import '../widgets/pixel_card.dart';
import '../models/user_model.dart';
import '../theme/pixel_colors.dart';
import '../services/log_service.dart';

class StudentPanel extends StatefulWidget {
  final UserModel user;

  const StudentPanel({super.key, required this.user});

  @override
  State<StudentPanel> createState() => _StudentPanelState();
}

class _StudentPanelState extends State<StudentPanel> {
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _handleClassMove(int fromDay, int toDay) {
    // Check constraints
    if (_currentUser.recuperacionesUsadas >= _currentUser.maxRecuperaciones) {
      _showPixelMessage('NO MORE RECOVERIES AVAILABLE!');
      return;
    }

    // TODO: Check if slot is available via Supabase
    
    setState(() {
      final updatedDias = List<int>.from(_currentUser.diasClase);
      updatedDias.remove(fromDay);
      updatedDias.add(toDay);
      
      _currentUser = UserModel(
        id: _currentUser.id,
        nombre: _currentUser.nombre,
        apellido1: _currentUser.apellido1,
        email: _currentUser.email,
        fechaAlta: _currentUser.fechaAlta,
        diasClase: updatedDias,
        recuperacionesUsadas: _currentUser.recuperacionesUsadas + 1,
        maxRecuperaciones: _currentUser.maxRecuperaciones,
        rol: _currentUser.rol,
      );
    });
    
    _showPixelMessage('CLASS MOVED! LOGGED IN DUNGEON.');
  }

  void _showPixelMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PixelColors.accent,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HERO: ${_currentUser.nombre.toUpperCase()}'),
        backgroundColor: PixelColors.surface,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PixelCard(
              title: 'STATS',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('RECOVERIES', '${_currentUser.recuperacionesUsadas}/${_currentUser.maxRecuperaciones}'),
                  _buildStat('STATUS', _currentUser.status ? 'ACTIVE' : 'AWAY'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PixelCard(
              title: 'TRAINING SCHEDULE',
              child: PixelCalendar(
                user: _currentUser,
                onClassMoved: _handleClassMove,
              ),
            ),
            const SizedBox(height: 24),
            PixelCard(
              title: 'DUNGEON LOGS',
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: LogService().getLatestLogs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('- The dungeon is silent...', style: TextStyle(fontSize: 8));
                  }
                  return Column(
                    children: snapshot.data!.map((log) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('- ${log['message']}', style: const TextStyle(fontSize: 8)),
                    )).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14, color: PixelColors.primary)),
      ],
    );
  }
}
