import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 🔥 टोकन स्टोरेज के लिए इम्पोर्ट जोड़ा

// पैकेज इम्पोर्ट्स
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
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // प्रीमियम डार्क थीम
      body: BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async { // 🔥 यहाँ async जोड़ा गया है
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('लॉगिन सफल! 🎉'),
                  backgroundColor: Colors.green,
                ),
              );

              // 🔐 टोकन को सुरक्षित लोकल स्टोरेज में सेव करना
              const storage = FlutterSecureStorage();
              
              // अगर आपका AuthSuccess डायरेक्ट मैप रिटर्न करता है या यूजर ऑब्जेक्ट, 
              // तो उसके अंदर से 'token' निकालकर सेव कर रहे हैं।
              final token = state.userData['token']; 
              if (token != null) {
                await storage.write(key: 'auth_token', value: token.toString());
              }
              
              // 🔥 डैशबोर्ड पर सुरक्षित नेविगेट करें
              if (context.mounted) {
                context.go('/dashboard');
              }
              
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'TAO BOOST',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Color(0xFF38BDF8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bittensor Intelligence Staking',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // ईमेल इनपुट फ़ील्ड
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF38BDF8)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1E293B),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'कृपया ईमेल दर्ज करें';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                              return 'कृपया एक वैध ईमेल दर्ज करें';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // पासवर्ड इनपुट फ़ील्ड
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF38BDF8)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: const Color(0xFF94A3B8),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1E293B),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'कृपया पासवर्ड दर्ज करें' : null,
                        ),
                        const SizedBox(height: 32),

                        // लॉगिन बटन
                        ElevatedButton(
                           state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          LoginSubmitted(
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text.trim(),
                                          ),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38BDF8),
                            foregroundColor: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0F172A),
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}