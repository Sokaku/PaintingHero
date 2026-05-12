class UserModel {
  final String id;
  final String nombre;
  final String apellido1;
  final String? apellido2;
  final DateTime fechaAlta;
  final DateTime? fechaBaja;
  final bool status;
  final String email;
  final double? cuota;
  final List<int> diasClase;
  final int maxRecuperaciones;
  final int recuperacionesUsadas;
  final int rol; // 0 = Admin, 1 = Student

  UserModel({
    required this.id,
    required this.nombre,
    required this.apellido1,
    this.apellido2,
    required this.fechaAlta,
    this.fechaBaja,
    this.status = true,
    required this.email,
    this.cuota,
    required this.diasClase,
    this.maxRecuperaciones = 2,
    this.recuperacionesUsadas = 0,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      apellido1: json['apellido_1'],
      apellido2: json['apellido_2'],
      fechaAlta: DateTime.parse(json['fecha_alta']),
      fechaBaja: json['fecha_baja'] != null ? DateTime.parse(json['fecha_baja']) : null,
      status: json['status'] ?? true,
      email: json['email'],
      cuota: json['cuota']?.toDouble(),
      diasClase: List<int>.from(json['dias_clase'] ?? []),
      maxRecuperaciones: json['max_recuperaciones'] ?? 2,
      recuperacionesUsadas: json['recuperaciones_usadas'] ?? 0,
      rol: json['rol'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido_1': apellido1,
      'apellido_2': apellido2,
      'fecha_alta': fechaAlta.toIso8601String().split('T')[0],
      'fecha_baja': fechaBaja?.toIso8601String().split('T')[0],
      'status': status,
      'email': email,
      'cuota': cuota,
      'dias_clase': diasClase,
      'max_recuperaciones': maxRecuperaciones,
      'recuperaciones_usadas': recuperacionesUsadas,
      'rol': rol,
    };
  }
}
