import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  final _supabase = Supabase.instance.client;

  // Obtener cuántas plazas quedan libres para una fecha específica
  Future<int> getFreeSlots(DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await _supabase
          .from('asistencias')
          .select('id')
          .eq('fecha', dateStr);
      
      final occupied = response.length;
      return 10 - occupied; // Máximo 10 alumnos
    } catch (e) {
      print('Error al contar plazas: $e');
      return 0;
    }
  }

  // Mover una asistencia de un día a otro
  Future<bool> moveAttendance({
    required String alumnoId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final fromStr = fromDate.toIso8601String().split('T')[0];
      final toStr = toDate.toIso8601String().split('T')[0];

      // Actualizamos la fecha de la asistencia
      // Si no existe (porque es el día regular y no hay fila aún), la creamos
      final existing = await _supabase
          .from('asistencias')
          .select()
          .eq('alumno_id', alumnoId)
          .eq('fecha', fromStr)
          .maybeSingle();

      if (existing != null) {
        await _supabase
            .from('asistencias')
            .update({'fecha': toStr, 'tipo': 'recuperacion'})
            .eq('id', existing['id']);
      } else {
        await _supabase.from('asistencias').insert({
          'alumno_id': alumnoId,
          'fecha': toStr,
          'tipo': 'recuperacion'
        });
      }
      return true;
    } catch (e) {
      print('Error al mover asistencia: $e');
      return false;
    }
  }

  // Borrar una asistencia (Falta sin recuperación)
  Future<bool> deleteAttendance(String alumnoId, DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      await _supabase
          .from('asistencias')
          .delete()
          .eq('alumno_id', alumnoId)
          .eq('fecha', dateStr);
      return true;
    } catch (e) {
      print('Error al borrar asistencia: $e');
      return false;
    }
  }
}
