import 'package:flutter/material.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_card.dart';
import '../theme/pixel_colors.dart';
import '../widgets/metro_logo.dart';
import '../services/supabase_service.dart';
import 'admin_panel.dart';
import 'student_panel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _supabaseService = SupabaseService();

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        throw Exception('RELLENA TODOS LOS CAMPOS, HÉROE');
      }

      await _supabaseService.signIn(email, password);
      final profile = await _supabaseService.getCurrentUserProfile();

      if (profile == null) throw Exception('PERFIL NO ENCONTRADO');

      if (!mounted) return;

      if (profile.rol == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminPanel()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => StudentPanel(user: profile)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString().replaceAll('Exception: ', '').toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // New Metro Logo
              const MetroLogo(size: 150),
              const SizedBox(height: 24),
              const Text(
                'PUSSY STATION',
                style: TextStyle(
                  fontSize: 24,
                  color: PixelColors.primary,
                  shadows: [
                    Shadow(color: Colors.black, offset: Offset(4, 4)),
                  ],
                ),
              ),
              const Text(
                'ACADEMY',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 48),
              PixelCard(
                title: 'ENTER DUNGEON',
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'EMAIL'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'PASS'),
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const CircularProgressIndicator(color: PixelColors.primary)
                    else
                      PixelButton(
                        text: 'LOGIN',
                        onPressed: _handleLogin,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
