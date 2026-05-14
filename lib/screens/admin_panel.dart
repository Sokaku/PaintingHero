import 'package:flutter/material.dart';
import '../widgets/pixel_card.dart';
import '../widgets/pixel_button.dart';
import '../theme/pixel_colors.dart';
import '../models/user_model.dart';
import '../models/school_year_model.dart';
import '../services/school_year_service.dart';
import 'package:intl/intl.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SchoolYearService _yearService = SchoolYearService();
  SchoolYearConfig _config = SchoolYearConfig.defaultConfig();
  bool _isLoading = true;
  
  final List<UserModel> _students = [
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _yearService.getActiveConfig();
    if (config != null && mounted) {
      setState(() {
        _config = config;
        _isLoading = false;
      });
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfig() async {
    setState(() => _isLoading = true);
    final success = await _yearService.saveConfig(_config);
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: success ? Colors.green : Colors.red,
          content: Text(success ? 'AÑO ESCOLAR GUARDADO EN DB ✅' : 'ERROR AL GUARDAR ❌'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PixelColors.background,
      appBar: AppBar(
        title: const Text('GOD MODE - ADMIN', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: PixelColors.primary,
          tabs: const [
            Tab(text: 'AÑO ESCOLAR'),
            Tab(text: 'ALUMNOS'),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: PixelColors.primary))
        : TabBarView(
            controller: _tabController,
            children: [
              _buildYearConfig(),
              _buildStudentsList(),
            ],
          ),
    );
  }

  Widget _buildYearConfig() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PixelCard(
            title: 'PERIODO LECTIVO',
            child: Column(
              children: [
                _buildDateRow('INICIO:', _config.startDate),
                const Divider(color: Colors.white10),
                _buildDateRow('FIN:', _config.endDate),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PixelCard(
            title: 'VACACIONES NAVIDAD',
            child: Column(
              children: [
                Text(
                  'DEL ${DateFormat('d MMMM').format(DateTime.parse(_config.holidays.first['inicio'])).toUpperCase()} AL ${DateFormat('d MMMM').format(DateTime.parse(_config.holidays.first['fin'])).toUpperCase()}',
                  style: const TextStyle(fontSize: 10, color: PixelColors.primary),
                ),
                const SizedBox(height: 8),
                const Text('ESTOS DÍAS NO SERÁN RECUPERABLES', style: TextStyle(fontSize: 8, color: Colors.white54)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PixelCard(
            title: 'DÍAS Y HORARIOS',
            child: Column(
              children: [1, 2, 3, 4, 5].map((day) {
                final dayName = ['LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES'][day - 1];
                final isActive = _config.activeDays.contains(day);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isActive,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _config.activeDays.add(day);
                            } else {
                              _config.activeDays.remove(day);
                            }
                          });
                        },
                        activeColor: PixelColors.primary,
                      ),
                      Expanded(child: Text(dayName, style: const TextStyle(fontSize: 10))),
                      if (isActive)
                        SizedBox(
                          width: 120,
                          child: TextField(
                            style: const TextStyle(fontSize: 10, color: PixelColors.primary),
                            decoration: const InputDecoration(
                              hintText: '17:00-19:00',
                              hintStyle: TextStyle(fontSize: 8, color: Colors.white24),
                              isDense: true,
                              border: UnderlineInputBorder(borderSide: BorderSide(color: PixelColors.primary)),
                            ),
                            controller: TextEditingController(text: _config.schedules[day.toString()] ?? '17:00-19:00')
                              ..selection = TextSelection.fromPosition(TextPosition(offset: (_config.schedules[day.toString()] ?? '17:00-19:00').length)),
                            onChanged: (val) {
                              _config.schedules[day.toString()] = val;
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
          PixelButton(
            text: 'GUARDAR CONFIGURACIÓN',
            onPressed: _saveConfig,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
                    title: Text(s.nombre.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    subtitle: Text('CLASES: ${s.diasClase.map((d) => ["L", "M", "X", "J", "V"][d-1]).join(", ")}', style: const TextStyle(fontSize: 10)),
                    trailing: const Icon(Icons.edit, size: 20, color: PixelColors.primary),
                  ),
                );
              },
            ),
          ),
          PixelButton(
            text: 'INVOCAR NUEVO ALUMNO',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10)),
        Text(
          DateFormat('dd / MM / yyyy').format(date),
          style: const TextStyle(color: PixelColors.primary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
