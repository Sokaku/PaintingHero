import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/school_year_model.dart';

class SchoolYearService {
  final _supabase = Supabase.instance.client;

  // Obtener la configuración activa
  Future<SchoolYearConfig?> getActiveConfig() async {
    try {
      final response = await _supabase
          .from('config_curso')
          .select()
          .eq('activo', true)
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
}
