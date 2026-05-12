import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   //Initialize Supabase
   await Supabase.initialize(
     url: 'euadogyusjlhwatkfveo',
     anonKey: 'sb_publishable_VlPe3PJOX3yR4gr1nwk9pQ_7vxJqMQa',
   );

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
      title: 'Painting Hero Academy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.pixelTheme,
      home: const LoginScreen(),
    );
  }
}
