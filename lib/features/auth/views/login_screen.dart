import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tao_boost/core/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 🔐 मैन्युअल एरर स्टेट्स (क्रोम के जिद्दी ऑटो-फ़िल पीले रंग को बाईपास करने के लिए भाई)
  String? _emailError;
  String? _passwordError;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🎯 कड़क मैन्युअल वैलिडेशन और लॉगिन लॉजिक भाई
  void handleLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    bool isValid = true;

    if (email.isEmpty) {
      _emailError = 'कृपया अपना ईमेल डालें भाई';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'कृपया एक सही ईमेल एड्रेस डालें भाई';
      isValid = false;
    }

    if (password.isEmpty) {
      _passwordError = 'कृपया अपना पासवर्ड डालें भाई';
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    final authNotifier = ref.read(authRepositoryProvider);
    
    try {
      final result = await authNotifier.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (!mounted) return;

      if (result == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 स्वागत है भाई! लॉगिन सफल हुआ।🚀'),
            backgroundColor: Color(0xFF1E293B),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('गड़बड़: $result'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // 🎨 कड़क नियॉन थीम कलर्स भाई (Dashboard और K1 Club से 100% परफेक्ट मैचिंग)
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const darkBackground = Color(0xFF0F172A); // डीप स्पेस लक्ज़री ब्लू-ब्लैक
    const cardColor = Color(0xFF1E293B);      // प्रीमियम कार्ड सरफेस
    const borderTextColor = Color(0xFF334155);

    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420), // वेब रिस्पॉन्सिवनेस के लिए
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: cardColor,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🚀 ऐप लोगो एनीमेशन आइकॉन
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: neonCyan.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: neonCyan,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 🔥 हेडिंग
                    const Center(
                      child: Text(
                        'TAO BOOST',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: neonCyan,
                          letterSpacing: 2.5,
                          shadows: [
                            Shadow(color: neonCyan, blurRadius: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: const Text(
                        'Bittensor Intelligence Staking',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // 📧 ईमेल इनपुट फ़ील्ड (Autofill fully bypassed via plain text type)
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.text, // 👈 क्रोम के ऑटो-फिल इंजन को अंधा करने की चाबी भाई
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      decoration: InputDecoration(
                        errorText: _emailError,
                        prefixIcon: const Icon(Icons.email_outlined, color: neonCyan, size: 20),
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500),
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
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🔑 पासवर्ड इनपुट फ़ील्ड (Autofill fully bypassed via plain text with obscure)
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.text, // 👈 यहाँ भी साधारण टेक्स्ट ताकि पीलापन न आए
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      decoration: InputDecoration(
                        errorText: _passwordError,
                        prefixIcon: const Icon(Icons.lock_outline, color: neonCyan, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                            color: const Color(0xFF475569),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500),
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
                      ),
                    ),
                    
                    // 🔄 पासवर्ड भूल गए?
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        style: TextButton.styleFrom(foregroundColor: neonCyan.withOpacity(0.8)),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(fontSize: 13, decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔘 प्रीमियम डार्क नियॉन लॉगिन बटन
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: authState.isLoading 
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
                        onPressed: authState.isLoading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: neonCyan,
                          foregroundColor: const Color(0xFF06111C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF06111C),
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 📝 नया चमचमाता हुआ नियॉन साइनअप लिंक
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/signup'),
                        style: TextButton.styleFrom(foregroundColor: neonCyan),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                            children: const [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: neonGreen,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}