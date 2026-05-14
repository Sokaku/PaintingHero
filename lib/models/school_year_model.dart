import 'package:flutter/material.dart';

class SchoolYearConfig {
  String? id;
  String nombre;
  DateTime startDate;
  DateTime endDate;
  List<int> activeDays;
  Map<String, dynamic> schedules;
  List<dynamic> holidays;
  bool isActive; // Nuevo campo para controlar el estado real

  SchoolYearConfig({
    this.id,
    required this.nombre,
    required this.startDate,
    required this.endDate,
    required this.activeDays,
    required this.schedules,
    required this.holidays,
    this.isActive = true,
  });

  factory SchoolYearConfig.fromMap(Map<String, dynamic> map) {
    return SchoolYearConfig(
      id: map['id'],
      nombre: map['nombre'] ?? 'CURSO ACTUAL',
      startDate: DateTime.parse(map['fecha_inicio']),
      endDate: DateTime.parse(map['fecha_fin']),
      activeDays: List<int>.from(map['dias_semana'] ?? []),
      schedules: map['horarios'] ?? {},
      holidays: map['vacaciones'] ?? [],
      isActive: map['activo'] ?? false, // Mapeamos el campo de la DB
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fecha_inicio': startDate.toIso8601String(),
      'fecha_fin': endDate.toIso8601String(),
      'dias_semana': activeDays,
      'horarios': schedules,
      'vacaciones': holidays,
      'activo': isActive,
    };
  }

  factory SchoolYearConfig.defaultConfig() {
    final now = DateTime.now();
    return SchoolYearConfig(
      nombre: 'CURSO ACTUAL',
      startDate: DateTime(now.year, 9, 15),
      endDate: DateTime(now.year + 1, 6, 15),
      activeDays: [1, 2, 3, 4, 5],
      schedules: {"1": "17:00-19:00", "2": "17:00-19:00", "3": "17:00-19:00", "4": "17:00-19:00", "5": "17:00-19:00"},
      holidays: [{"inicio": "2024-12-15", "fin": "2025-01-15"}],
      isActive: true,
    );
  }
}
