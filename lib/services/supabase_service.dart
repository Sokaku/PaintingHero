import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/recovery_model.dart';
import '../models/waitlist_model.dart';
import '../models/notification_model.dart';

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

  // --- Recovery and Waitlist Logic ---

  Future<void> requestRecovery(String studentId, DateTime fechaAusencia, DateTime fechaRecuperacion) async {
    // 1. Validate 15 days rule (before or after)
    final difference = fechaRecuperacion.difference(fechaAusencia).inDays.abs();
    if (difference > 15) {
      throw Exception('La recuperación debe ser 15 días antes o después de la falta.');
    }

    // 2. Validate max 2 per month
    final startOfMonth = DateTime(fechaAusencia.year, fechaAusencia.month, 1);
    final endOfMonth = DateTime(fechaAusencia.year, fechaAusencia.month + 1, 0);

    final currentMonthRecoveries = await _client
        .from('recuperaciones')
        .select()
        .eq('student_id', studentId)
        .gte('fecha_ausencia', startOfMonth.toIso8601String().split('T')[0])
        .lte('fecha_ausencia', endOfMonth.toIso8601String().split('T')[0]);

    if ((currentMonthRecoveries as List).length >= 2) {
      throw Exception('Límite de 2 recuperaciones mensuales alcanzado.');
    }

    // 3. Create Recovery
    final recovery = RecoveryModel(
      id: '',
      studentId: studentId,
      fechaAusencia: fechaAusencia,
      fechaRecuperacion: fechaRecuperacion,
      createdAt: DateTime.now(),
    );

    final recoveryResponse = await _client.from('recuperaciones').insert(recovery.toJson()).select().single();
    final createdRecovery = RecoveryModel.fromJson(recoveryResponse);

    // 4. Check if slot is available
    bool isSlotAvailable = await _checkSlotAvailability(fechaRecuperacion);
    
    if (isSlotAvailable) {
      // Confirm recovery directly
      await _client.from('recuperaciones').update({'status': 'completada'}).eq('id', createdRecovery.id);
    } else {
      // Put in queue by annotation order
      final waitlistEntry = WaitlistModel(
        id: '',
        studentId: studentId,
        recoveryId: createdRecovery.id,
        fechaDeseada: fechaRecuperacion,
        createdAt: DateTime.now(),
      );
      await _client.from('cola_recuperacion').insert(waitlistEntry.toJson());
    }
  }

  Future<bool> _checkSlotAvailability(DateTime date) async {
    // Placeholder logic for checking slot availability
    return false; // Assumes false for now, triggering waitlist logic
  }

  Future<void> cancelClassAndNotify(String studentId, DateTime fechaAusencia) async {
    // When a student cancels their class, a spot becomes available.
    
    // 1. Check waitlist for this specific day (ordered by creation time to respect "orden de anotación")
    final waitlistResponse = await _client
        .from('cola_recuperacion')
        .select()
        .eq('fecha_deseada', fechaAusencia.toIso8601String().split('T')[0])
        .order('created_at', ascending: true)
        .limit(1);

    if ((waitlistResponse as List).isNotEmpty) {
      // 2. Assign to the first student in the waitlist directly to the free spot
      final waitlistEntry = WaitlistModel.fromJson(waitlistResponse.first);
      
      await _client.from('recuperaciones').update({'status': 'completada'}).eq('id', waitlistEntry.recoveryId);
      await _client.from('cola_recuperacion').delete().eq('id', waitlistEntry.id);

      // Notify the assigned student via app notification
      final notification = NotificationModel(
        id: '',
        studentId: waitlistEntry.studentId,
        message: '¡Tienes plaza! Tu clase ha sido recuperada para el día ${fechaAusencia.toIso8601String().split('T')[0]}.',
        createdAt: DateTime.now(),
      );
      await _client.from('notificaciones').insert(notification.toJson());
    } else {
      // 3. If nobody is in queue, communicate the class change to everyone to warn of a free spot
      final notification = NotificationModel(
        id: '',
        message: '¡Hueco libre! Hay una plaza disponible el día ${fechaAusencia.toIso8601String().split('T')[0]}.',
        createdAt: DateTime.now(),
      );
      await _client.from('notificaciones').insert(notification.toJson());
    }
  }
}
