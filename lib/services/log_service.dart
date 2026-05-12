import 'package:supabase_flutter/supabase_flutter.dart';

class LogService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> logAction(String userId, String message) async {
    await _client.from('logs').insert({
      'user_id': userId,
      'message': message,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Map<String, dynamic>>> getLatestLogs() {
    return _client
        .from('logs')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(10);
  }
}
