import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  try {
    await Supabase.initialize(
      url: 'https://euadogyusjlhwatkfveo.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV1YWRvZ3l1c2psaHdhdGtmdmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg1ODUyMzYsImV4cCI6MjA5NDE2MTIzNn0._uiVX6Xy2InaIEMc7UDuXbGRgAiusYRaIHMULu2Qh4o',
    );
    debugPrint("--- Supabase inicializado correctamente ---");
  } catch (e) {
    debugPrint("--- ERROR al inicializar Supabase: $e ---");
  }

  runApp(
    const ProviderScope(
      child: PaintingHeroApp(),
    ),
  );
}

class PaintingHeroApp extends StatelessWidget {
  const PaintingHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pussy Station',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.pixelTheme,
      home: const LoginScreen(),
    );
  }
}
