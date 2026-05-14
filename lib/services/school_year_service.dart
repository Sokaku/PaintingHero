import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/school_year_model.dart';

class SchoolYearService {
  final _supabase = Supabase.instance.client;

  // Obtener todos los cursos creados (historial)
  Future<List<SchoolYearConfig>> getAllConfigs() async {
    try {
      final response = await _supabase
          .from('config_curso')
          .select()
          .order('fecha_alta', ascending: false);
      
      return (response as List).map((m) => SchoolYearConfig.fromMap(m)).toList();
    } catch (e) {
      print('Error al obtener historial de cursos: $e');
      return [];
    }
  }

  // Obtener la configuración activa (la que está en vigor)
  Future<SchoolYearConfig?> getActiveConfig() async {
    try {
      final response = await _supabase
          .from('config_curso')
          .select()
          .eq('activo', true)
          .order('fecha_alta', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return SchoolYearConfig.fromMap(response);
    } catch (e) {
      print('Error al obtener config curso: $e');
      return null;
    }
  }

  // Guardar o actualizar la configuración
  Future<bool> saveConfig(SchoolYearConfig config) async {
    try {
      if (config.id != null) {
        await _supabase
            .from('config_curso')
            .update(config.toMap())
            .eq('id', config.id!);
      } else {
        await _supabase.from('config_curso').insert(config.toMap());
      }
      return true;
    } catch (e) {
      print('Error al guardar config curso: $e');
      return false;
    }
  }

  // Cerrar el año escolar (llama a la función RPC de Supabase)
  Future<bool> closeSchoolYear(String id) async {
    try {
      await _supabase.rpc('cerrar_curso_escolar', params: {'curso_id': id});
      return true;
    } catch (e) {
      print('Error al cerrar año escolar: $e');
      return false;
    }
  }

  // Borrar físicamente un curso
  Future<bool> deleteConfig(String id) async {
    try {
      await _supabase.from('config_curso').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error al borrar curso: $e');
      return false;
    }
  }
}
