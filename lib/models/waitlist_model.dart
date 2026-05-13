class WaitlistModel {
  final String id;
  final String studentId;
  final String recoveryId; // The ID of the recovery this waitlist entry is for
  final DateTime fechaDeseada; // The date they want to recover on
  final DateTime createdAt;

  WaitlistModel({
    required this.id,
    required this.studentId,
    required this.recoveryId,
    required this.fechaDeseada,
    required this.createdAt,
  });

  factory WaitlistModel.fromJson(Map<String, dynamic> json) {
    return WaitlistModel(
      id: json['id'].toString(),
      studentId: json['student_id'].toString(),
      recoveryId: json['recovery_id'].toString(),
      fechaDeseada: DateTime.parse(json['fecha_deseada']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'student_id': studentId,
      'recovery_id': recoveryId,
      'fecha_deseada': fechaDeseada.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
    };
  }
}
