import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Auth
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // User Profile
  Future<UserModel?> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('usuarios')
        .select()
        .eq('id', user.id)
        .single();
    
    return UserModel.fromJson(response);
  }

  // Admin Operations
  Future<List<UserModel>> getAllStudents() async {
    final response = await _client
        .from('usuarios')
        .select()
        .eq('rol', 1)
        .order('nombre');
    
    return (response as List).map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> createStudent(UserModel student) async {
    await _client.from('usuarios').insert(student.toJson());
  }

  Future<void> updateStudent(UserModel student) async {
    await _client.from('usuarios').update(student.toJson()).eq('id', student.id);
  }

  // Calendar / Slots (Placeholder for now)
  Future<List<Map<String, dynamic>>> getAvailableSlots(int dayOfWeek) async {
    // Logic to calculate availability based on other students' dias_clase
    // and room capacity (e.g., 5 students max per slot)
    return [];
  }
}
