import 'package:flutter/material.dart';
import '../widgets/pixel_calendar.dart';
import '../widgets/pixel_card.dart';
import '../widgets/pixel_button.dart';
import '../models/user_model.dart';
import '../theme/pixel_colors.dart';
import '../services/log_service.dart';

import 'recovery_selection_screen.dart';
import '../services/attendance_service.dart';
import 'package:intl/intl.dart';

class StudentPanel extends StatefulWidget {
  final UserModel user;

  const StudentPanel({super.key, required this.user});

  @override
  State<StudentPanel> createState() => _StudentPanelState();
}

class _StudentPanelState extends State<StudentPanel> {
  late UserModel _currentUser;
  DateTime? _selectedAbsenceDate;
  final AttendanceService _attendanceService = AttendanceService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _startRecoveryFlow() async {
    if (_selectedAbsenceDate == null) return;

    final result = await Navigator.push<DateTime>(
      context,
      MaterialPageRoute(
        builder: (_) => RecoverySelectionScreen(
          user: _currentUser,
          absenceDate: _selectedAbsenceDate!,
        ),
      ),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      
      final success = await _attendanceService.moveAttendance(
        alumnoId: _currentUser.id,
        fromDate: _selectedAbsenceDate!,
        toDate: result,
      );

      if (success) {
        setState(() {
          _currentUser = UserModel(
            id: _currentUser.id,
            nombre: _currentUser.nombre,
            apellido1: _currentUser.apellido1,
            email: _currentUser.email,
            fechaAlta: _currentUser.fechaAlta,
            diasClase: _currentUser.diasClase,
            recuperacionesUsadas: _currentUser.recuperacionesUsadas + 1,
            maxRecuperaciones: _currentUser.maxRecuperaciones,
            rol: _currentUser.rol,
          );
          _selectedAbsenceDate = null;
          _isLoading = false;
        });
        _showPixelMessage('¡RECUPERACIÓN GUARDADA PARA EL ${DateFormat('d/M').format(result)}!');
      } else {
        setState(() => _isLoading = false);
        _showPixelMessage('ERROR AL GUARDAR EL CAMBIO ❌');
      }
    }
  }

  void _showPixelMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PixelColors.primary,
        content: Text(
          message,
          style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PixelColors.background,
      appBar: AppBar(
        title: Text('HERO: ${_currentUser.nombre.toUpperCase()}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pop(context)),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: PixelColors.primary))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
            PixelCard(
              title: 'MIS STATS',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('RECUPERACIONES', '${_currentUser.recuperacionesUsadas}/${_currentUser.maxRecuperaciones}'),
                  _buildStat('ESTADO', _currentUser.status ? 'ACTIVO' : 'BAJA'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('ESTA SEMANA:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            _buildWeeklyView(),
            const SizedBox(height: 32),
            if (_selectedAbsenceDate != null)
              Column(
                children: [
                  const Text('HAS MARCADO QUE NO VENDRÁS EL:', style: TextStyle(fontSize: 10)),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE d MMMM', 'es_ES').format(_selectedAbsenceDate!).toUpperCase(),
                    style: const TextStyle(color: PixelColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: PixelButton(
                      text: 'BUSCAR RECUPERACIÓN',
                      onPressed: _startRecoveryFlow,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyView() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      children: List.generate(5, (index) {
        final date = monday.add(Duration(days: index));
        final isClassDay = _currentUser.diasClase.contains(date.weekday);
        final isSelected = _selectedAbsenceDate?.day == date.day && _selectedAbsenceDate?.month == date.month;

        return Expanded(
          child: GestureDetector(
            onTap: isClassDay ? () => setState(() => _selectedAbsenceDate = date) : null,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? PixelColors.primary : (isClassDay ? PixelColors.surface : Colors.black26),
                border: Border.all(
                  color: isSelected ? Colors.white : (isClassDay ? PixelColors.primary : Colors.white10),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    ['L', 'M', 'X', 'J', 'V'][index],
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.black : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                  if (isClassDay && !isSelected)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(Icons.brush, size: 12, color: PixelColors.primary),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14, color: PixelColors.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
