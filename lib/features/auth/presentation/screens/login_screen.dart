import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

import 'package:tao_boost/core/di/service_locator.dart'; 
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 🔐 मैन्युअल एरर स्टेट्स (क्रोम के पीले ऑटो-फ़िल को ब्लॉक करने के लिए फॉर्म की जगह डायरेक्ट वैलिडेशन भाई)
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🎯 कड़क वैलिडेशन लॉजिक भाई
  bool _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    bool isValid = true;

    if (email.isEmpty) {
      _emailError = 'Please enter your email address';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Please enter a valid email address';
      isValid = false;
    }

    if (password.isEmpty) {
      _passwordError = 'Please enter your password';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const darkBackground = Color(0xFF0B0F19); 
    const cardBackground = Color(0xFF131C2E); 
    const borderTextColor = Color(0xFF1E293B); 

    return Scaffold(
      backgroundColor: darkBackground, 
      body: BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async { 
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: cardBackground,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: neonGreen, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Login successful! Welcome aboard.', 
                        style: TextStyle(color: neonCyan, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );

              const storage = FlutterSecureStorage();
              final token = state.userData['token']; 
              if (token != null) {
                await storage.write(key: 'auth_token', value: token.toString());
              }
              
              if (context.mounted) {
                context.go('/dashboard');
              }
              
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF1E293B),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.errorMessage, 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Stack(
                children: [
                  // ✨ प्रीमियम एम्बिएंट ग्लो इफेक्ट्स
                  Positioned(
                    top: -80,
                    right: -80,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: neonCyan.withOpacity(0.04),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -60,
                    left: -60,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1E1B4B).withOpacity(0.3),
                      ),
                    ),
                  ),

                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 420),
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: neonCyan.withOpacity(0.15), width: 1), 
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'TAO BOOST',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.5,
                                color: neonCyan, 
                                shadows: [
                                  Shadow(color: neonCyan, blurRadius: 12), 
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Bittensor Intelligence Staking',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // 📧 ईमेल इनपुट फ़ील्ड (Autofill fully bypassed via plain text type)
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.text, // 👈 क्रोम को अंधा करने की चाबी भाई
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13),
                                errorText: _emailError,
                                prefixIcon: const Icon(Icons.email_outlined, color: neonCyan, size: 20),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: borderTextColor, width: 1.2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: neonCyan, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                                ),
                                filled: true,
                                fillColor: darkBackground.withOpacity(0.5),
                                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 🔒 पासवर्ड इनपुट फ़ील्ड (Autofill fully bypassed via plain text type with obscuring)
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.text, // 👈 यहाँ भी साधारण टेक्स्ट भाई
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13),
                                errorText: _passwordError,
                                prefixIcon: const Icon(Icons.lock_outline, color: neonCyan, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: const Color(0xFF475569),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: borderTextColor, width: 1.2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: neonCyan, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                                ),
                                filled: true,
                                fillColor: darkBackground.withOpacity(0.5),
                                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                              ),
                            ),
                            const SizedBox(height: 36),

                            // ⚡ साइन इन सबमिट बटन
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: state is AuthLoading 
                                  ? [] 
                                  : [
                                      BoxShadow(
                                        color: neonCyan.withOpacity(0.25), 
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                              ),
                              child: ElevatedButton(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (_validateForm()) {
                                          context.read<AuthBloc>().add(
                                                LoginSubmitted(
                                                  email: _emailController.text.trim(),
                                                  password: _passwordController.text.trim(),
                                                ),
                                              );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: neonCyan,
                                  foregroundColor: const Color(0xFF06111C),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: state is AuthLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF06111C),
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        'SIGN IN',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}