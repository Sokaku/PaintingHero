import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/pixel_card.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_avatar.dart';
import '../widgets/pixel_avatar_editor.dart';
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
  final List<SchoolYearConfig> _schoolYears = [];
  bool _isLoading = true;
  bool _showInactive = false;
  final List<UserModel> _students = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _loadSchoolYears();
    await _loadStudents();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadSchoolYears() async {
    final years = await _yearService.getAllConfigs();
    if (mounted) {
      setState(() {
        _schoolYears.clear();
        _schoolYears.addAll(years);
      });
    }
  }

  Future<void> _loadStudents() async {
    try {
      final response = await Supabase.instance.client
          .from('usuarios')
          .select()
          .eq('rol', 1)
          .order('nombre');
      
      if (mounted) {
        setState(() {
          _students.clear();
          _students.addAll((response as List).map((m) => UserModel.fromJson(m)));
        });
      }
    } catch (e) {
      print('Error cargando alumnos: $e');
    }
  }

  void _showStudentForm(UserModel? student) {
    final isEditing = student != null;
    final nameController = TextEditingController(text: student?.nombre);
    final apellido1Controller = TextEditingController(text: student?.apellido1);
    final apellido2Controller = TextEditingController(text: student?.apellido2);
    final emailController = TextEditingController(text: student?.email);
    List<int> selectedDays = List.from(student?.diasClase ?? []);
    bool isActive = student?.status ?? true;
    Map<String, dynamic> avatarConfig = Map.from(student?.avatarConfig ?? {'head': 1, 'torso': 1, 'legs': 1});

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: PixelColors.background,
            title: Text(isEditing ? 'EDITAR HÉROE' : 'INVOCAR NUEVO HÉROE', style: const TextStyle(fontSize: 14)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('TOCA PARA CAMBIAR APARIENCIA:', style: TextStyle(fontSize: 10, color: Colors.white70)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PixelAvatarEditor(
                          initialConfig: avatarConfig,
                          onSave: (newConfig) {
                            setDialogState(() {
                              avatarConfig['head'] = newConfig['head'];
                              avatarConfig['torso'] = newConfig['torso'];
                              avatarConfig['legs'] = newConfig['legs'];
                            });
                          },
                        ),
                      );
                    },
                    child: Center(child: PixelAvatar(config: avatarConfig, size: 100)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(labelText: 'NOMBRE', labelStyle: TextStyle(fontSize: 10, color: PixelColors.primary)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: apellido1Controller,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(labelText: 'PRIMER APELLIDO', labelStyle: TextStyle(fontSize: 10, color: PixelColors.primary)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: apellido2Controller,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(labelText: 'SEGUNDO APELLIDO', labelStyle: TextStyle(fontSize: 10, color: PixelColors.primary)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(labelText: 'EMAIL', labelStyle: TextStyle(fontSize: 10, color: PixelColors.primary)),
                  ),
                  const SizedBox(height: 24),
                  const Text('DÍAS DE CLASE:', style: TextStyle(fontSize: 10, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [1, 2, 3, 4, 5].map((d) {
                      final isSel = selectedDays.contains(d);
                      return GestureDetector(
                        onTap: () => setDialogState(() {
                          if (isSel) selectedDays.remove(d); else selectedDays.add(d);
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSel ? PixelColors.primary : Colors.transparent,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(['L', 'M', 'X', 'J', 'V'][d - 1], 
                            style: TextStyle(fontSize: 10, color: isSel ? Colors.black : Colors.white)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('ESTADO:', style: TextStyle(fontSize: 10)),
                      const Spacer(),
                      Text(isActive ? 'ACTIVO' : 'INACTIVO (ZZZ)', 
                        style: TextStyle(fontSize: 9, color: isActive ? Colors.green : Colors.blueAccent)),
                      Switch(
                        value: isActive, 
                        onChanged: (v) => setDialogState(() => isActive = v),
                        activeColor: PixelColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
              TextButton(
                onPressed: () async {
                  try {
                    final data = {
                      'nombre': nameController.text,
                      'apellido_1': apellido1Controller.text,
                      'apellido_2': apellido2Controller.text,
                      'email': emailController.text,
                      'dias_clase': selectedDays,
                      'status': isActive,
                      'avatar_config': avatarConfig,
                      'rol': 1,
                    };

                    if (isEditing) {
                      await Supabase.instance.client.from('usuarios').update(data).eq('id', student.id);
                    } else {
                      // Generamos ID si la DB no lo hace por defecto
                      data['id'] = DateTime.now().millisecondsSinceEpoch.toString();
                      data['fecha_alta'] = DateTime.now().toIso8601String();
                      await Supabase.instance.client.from('usuarios').insert(data);
                    }
                    
                    if (mounted) {
                      Navigator.pop(context);
                      _loadStudents();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ERROR AL GUARDAR: $e')),
                      );
                    }
                  }
                },
                child: const Text('GUARDAR CAMBIOS', style: TextStyle(color: PixelColors.primary)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPartSelector(String label, String partKey, Map<String, dynamic> config, StateSetter setDialogState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white54)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: PixelColors.primary),
                onPressed: () => setDialogState(() {
                  int current = config[partKey] ?? 1;
                  config[partKey] = current > 1 ? current - 1 : 4;
                }),
              ),
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text('${config[partKey]}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: PixelColors.primary),
                onPressed: () => setDialogState(() {
                  int current = config[partKey] ?? 1;
                  config[partKey] = current < 4 ? current + 1 : 1;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PixelColors.background,
      appBar: AppBar(
        title: const Text('PUERTA DE CONTROL (ADMIN)', style: TextStyle(fontSize: 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              _buildSchoolYearTab(),
              _buildStudentsList(),
            ],
          ),
    );
  }

  Widget _buildSchoolYearTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: _schoolYears.isEmpty 
              ? const Center(child: Text('NO HAY AÑOS CONFIGURADOS', style: TextStyle(color: Colors.white54, fontSize: 10)))
              : ListView.builder(
                  itemCount: _schoolYears.length,
                  itemBuilder: (context, index) {
                    final year = _schoolYears[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: PixelColors.surface,
                        border: Border.all(color: year.isActive ? PixelColors.primary : Colors.white10),
                      ),
                      child: ListTile(
                        title: Text(year.nombre.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        subtitle: Text('${DateFormat('dd/MM/yy').format(year.startDate)} - ${DateFormat('dd/MM/yy').format(year.endDate)}', style: const TextStyle(fontSize: 10)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: year.isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                              ),
                              child: Text(year.isActive ? 'EN VIGOR' : 'CERRADO', style: TextStyle(fontSize: 8, color: year.isActive ? Colors.green : Colors.grey)),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20, color: PixelColors.primary),
                              onPressed: () => _showYearForm(year),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          const SizedBox(height: 16),
          PixelButton(
            text: 'NUEVO AÑO ESCOLAR',
            onPressed: () {
              final hasActive = _schoolYears.any((y) => y.id != null); // Simplificado para el ejemplo
              if (hasActive && _schoolYears.any((y) => y.id != null)) {
                 _showYearForm(null); // Permitir por ahora pero avisar dentro
              } else {
                _showYearForm(null);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showYearForm(SchoolYearConfig? year) {
    final isEditing = year != null;
    final config = year ?? SchoolYearConfig.defaultConfig();
    final nameController = TextEditingController(text: config.nombre);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: PixelColors.background,
            title: Text(isEditing ? 'EDITAR CURSO' : 'NUEVO CURSO', style: const TextStyle(fontSize: 14)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'NOMBRE DEL CURSO', labelStyle: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(height: 16),
                  _buildDateTile('INICIO', config.startDate, (d) => setDialogState(() => config.startDate = d)),
                  _buildDateTile('FIN', config.endDate, (d) => setDialogState(() => config.endDate = d)),
                  const SizedBox(height: 16),
                  const Text('DÍAS LECTIVOS Y HORARIOS:', style: TextStyle(fontSize: 10, color: Colors.white70)),
                  ...[1, 2, 3, 4, 5].map((d) {
                    final isSelected = config.activeDays.contains(d);
                    return Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (v) => setDialogState(() {
                            if (v!) config.activeDays.add(d); else config.activeDays.remove(d);
                          }),
                        ),
                        Text(['L', 'M', 'X', 'J', 'V'][d-1], style: const TextStyle(fontSize: 10)),
                        if (isSelected) Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextField(
                              decoration: const InputDecoration(hintText: 'HORARIO', hintStyle: TextStyle(fontSize: 8)),
                              style: const TextStyle(fontSize: 10),
                              onChanged: (v) => config.schedules[d.toString()] = v,
                              controller: TextEditingController(text: config.schedules[d.toString()] ?? ''),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            actions: [
              if (isEditing) ...[
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () => _showDeleteYearConfirmation(config),
                ),
                TextButton(
                  onPressed: () => _showCloseConfirmation(config), 
                  child: const Text('CERRAR CURSO', style: TextStyle(color: Colors.red, fontSize: 10)),
                ),
              ],
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text('CANCELAR', style: TextStyle(color: Colors.white54, fontSize: 10)),
              ),
              TextButton(
                onPressed: () async {
                  config.nombre = nameController.text;
                  await _yearService.saveConfig(config);
                  Navigator.pop(context);
                  _loadData();
                },
                child: const Text('GUARDAR', style: TextStyle(color: PixelColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showDeleteYearConfirmation(SchoolYearConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: PixelColors.surface,
        title: const Text('¿BORRAR DEFINITIVAMENTE?', style: TextStyle(color: Colors.red, fontSize: 14)),
        content: Text(
          '¿Estás seguro de que quieres eliminar el "${config.nombre}"? Esta acción no se puede deshacer.',
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cierra este diálogo
              Navigator.pop(context); // Cierra el formulario
              setState(() => _isLoading = true);
              final success = await _yearService.deleteConfig(config.id!);
              if (mounted) {
                setState(() => _isLoading = false);
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'CURSO ELIMINADO FÍSICAMENTE ✅' : 'ERROR AL BORRAR ❌')),
                );
              }
            },
            child: const Text('BORRAR AHORA', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCloseConfirmation(SchoolYearConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: PixelColors.surface,
        title: const Text('¿CERRAR CURSO?', style: TextStyle(color: Colors.white, fontSize: 14)),
        content: const Text(
          'Esto desactivará el curso actual y pondrá a todos los alumnos en estado de BAJA. ¿Estás seguro?',
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cierra este diálogo
              Navigator.pop(context); // Cierra el formulario
              setState(() => _isLoading = true);
              final success = await _yearService.closeSchoolYear(config.id!);
              if (mounted) {
                setState(() => _isLoading = false);
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'CURSO CERRADO Y ALUMNOS DADOS DE BAJA' : 'ERROR AL CERRAR')),
                );
              }
            },
            child: const Text('CERRAR CURSO', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList() {
    final filteredStudents = _students.where((s) => s.status == !_showInactive).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showInactive ? 'HÉROES EN RESERVA (ZZZ)' : 'HÉROES ACTIVOS',
                style: const TextStyle(fontSize: 10, color: PixelColors.primary, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: _showInactive,
                onChanged: (val) => setState(() => _showInactive = val),
                activeColor: PixelColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final s = filteredStudents[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: PixelColors.surface,
                    border: Border.all(
                      color: s.status ? PixelColors.border : Colors.white10,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    leading: PixelAvatar(config: s.avatarConfig, size: 40),
                    title: Text('${s.nombre} ${s.apellido1} ${s.apellido2 ?? ""}'.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'CLASES: ${s.diasClase.map((d) => ["L", "M", "X", "J", "V"][d-1]).join(", ")}',
                      style: const TextStyle(fontSize: 9, color: Colors.white54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!s.status) const Icon(Icons.nights_stay, size: 16, color: Colors.blueAccent),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: PixelColors.primary),
                          onPressed: () => _showStudentForm(s),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          PixelButton(
            text: 'INVOCAR NUEVO ALUMNO',
            onPressed: () => _showStudentForm(null),
          ),
          const SizedBox(height: 12),
          PixelButton(
            text: 'RESCATAR ALUMNOS (BAJAS)',
            color: PixelColors.secondary,
            onPressed: () => _showRescueDialog(),
          ),
        ],
      ),
    );
  }

  void _showRescueDialog() {
    // Implementación pendiente si es necesario, pero _showStudentForm ya puede activar alumnos
  }

  Widget _buildDateTile(String label, DateTime date, Function(DateTime) onSelect) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 8, color: Colors.white70)),
      subtitle: Text(DateFormat('dd / MM / yyyy').format(date), style: const TextStyle(color: PixelColors.primary, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.calendar_today, size: 16, color: PixelColors.primary),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onSelect(picked);
      },
    );
  }
}
