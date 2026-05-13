class NotificationModel {
  final String id;
  final String? studentId; // If null, it's a global notification
  final String message;
  final DateTime createdAt;
  final bool read;

  NotificationModel({
    required this.id,
    this.studentId,
    required this.message,
    required this.createdAt,
    this.read = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      studentId: json['student_id']?.toString(),
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (studentId != null) 'student_id': studentId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'read': read,
    };
  }
}
