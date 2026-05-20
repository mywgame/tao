import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tao_boost/core/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // 📝 मेमोरी और परफॉर्में性能 के लिए कंट्रोलर्स
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 🔐 मैन्युअल एरर स्टेट्स (क्रोम के जिद्दी पीले ऑटो-फ़िल को पूरी तरह ब्लॉक करने के लिए भाई)
  String? _emailError;
  String? _passwordError;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🎯 कड़क वैलिडेशन और साइनअप लॉजिक भाई
  void _handleSignup() async {
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
    } else if (password.length < 6) {
      _passwordError = 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए भाई';
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 🔥 फायरबेस/बैकएंड पर नया अकाउंट बनाने के लिए कॉल
    final result = await ref.read(authRepositoryProvider).signUpWithEmail(
          email: email,
          password: password,
        );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 अकाउंट सफलतापूर्वक बन गया! स्वागत है भाई। 🚀'),
          backgroundColor: Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/dashboard'); // सीधे डार्क डैशबोर्ड के अंदर एंट्री
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('गड़बड़: $result'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 प्रीमियम डार्क नियॉन कलर्स भाई (K1 Club और नए Login से 100% परफेक्ट मैचिंग)
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const darkBackground = Color(0xFF0F172A); // गहरा स्पेस लक्ज़री ब्लू-ब्लैक
    const cardColor = Color(0xFF1E293B);      // प्रीमियम कार्ड सरफेस
    const borderTextColor = Color(0xFF334155);

    return Scaffold(
      backgroundColor: darkBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420), // वेब रिस्पॉन्सिवनेस के लिए भाई
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
                        Icons.bolt_rounded, // TAO BOOST की फील देने के लिए
                        color: neonCyan,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 🔥 हेडिंग
                  const Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Join Tao Boost and start your journey',
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // ✉️ ईमेल फील्ड (Autofill bypassed via plain text type)
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
                    keyboardType: TextInputType.text, // 👈 क्रोम के पीले ऑटो-फिल को रोकने की निंजा टेक्निक भाई
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

                  // 🔒 पासवर्ड फील्ड (Autofill bypassed via plain text type with obscure)
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
                    keyboardType: TextInputType.text, // 👈 यहाँ भी साधारण टेक्स्ट ताकि पीला रंग न घुसे
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
                      hintText: 'Create strong password',
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
                  const SizedBox(height: 36),

                  // 🩵 नियॉन सियान प्रीमियम साइनअप बटन
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _isLoading 
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
                      onPressed: _isLoading ? null : _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neonCyan,
                        foregroundColor: const Color(0xFF06111C), // बटन के ऊपर डार्क टेक्स्ट किलर दिखेगा
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF06111C),
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 🔄 लॉगिन पर स्विच करने का लिंक (नियॉन ग्रीन हाइलाइट भाई)
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(foregroundColor: neonCyan),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                          children: const [
                            TextSpan(
                              text: 'Login',
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
    );
  }
}