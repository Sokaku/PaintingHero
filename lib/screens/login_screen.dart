import 'package:flutter/material.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_card.dart';
import '../theme/pixel_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hero Logo Placeholder
              Container(
                width: 100,
                height: 100,
                color: PixelColors.primary,
                child: const Icon(Icons.brush, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'PAINTING HERO',
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
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'PASS'),
                    ),
                    const SizedBox(height: 24),
                    PixelButton(
                      text: 'LOGIN',
                      onPressed: () {
                        // TODO: Implement Auth
                      },
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
