class RecoveryModel {
  final String id;
  final String studentId;
  final DateTime fechaAusencia; // Date the student missed/will miss
  final DateTime? fechaRecuperacion; // Date the student is recovering
  final String status; // 'pendiente', 'completada', 'cancelada'
  final DateTime createdAt;

  RecoveryModel({
    required this.id,
    required this.studentId,
    required this.fechaAusencia,
    this.fechaRecuperacion,
    this.status = 'pendiente',
    required this.createdAt,
  });

  factory RecoveryModel.fromJson(Map<String, dynamic> json) {
    return RecoveryModel(
      id: json['id'].toString(),
      studentId: json['student_id'].toString(),
      fechaAusencia: DateTime.parse(json['fecha_ausencia']),
      fechaRecuperacion: json['fecha_recuperacion'] != null ? DateTime.parse(json['fecha_recuperacion']) : null,
      status: json['status'] ?? 'pendiente',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'student_id': studentId,
      'fecha_ausencia': fechaAusencia.toIso8601String().split('T')[0],
      if (fechaRecuperacion != null) 'fecha_recuperacion': fechaRecuperacion!.toIso8601String().split('T')[0],
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
