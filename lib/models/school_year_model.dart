import 'package:flutter/material.dart';

class SchoolYearConfig {
  final String? id;
  final String nombre;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> activeDays;
  final Map<String, dynamic> schedules;
  final List<dynamic> holidays;

  SchoolYearConfig({
    this.id,
    required this.nombre,
    required this.startDate,
    required this.endDate,
    required this.activeDays,
    required this.schedules,
    required this.holidays,
  });

  factory SchoolYearConfig.fromMap(Map<String, dynamic> map) {
    return SchoolYearConfig(
      id: map['id'],
      nombre: map['nombre'],
      startDate: DateTime.parse(map['fecha_inicio']),
      endDate: DateTime.parse(map['fecha_fin']),
      activeDays: List<int>.from(map['dias_semana']),
      schedules: map['horarios'] ?? {},
      holidays: map['vacaciones'] ?? [],
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
    );
  }
}
