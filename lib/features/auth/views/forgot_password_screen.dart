import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tao_boost/core/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  
  // 🔐 मैन्युअल एरर स्टेट (क्रोम के ऑटो-फ़िल पीले रंग को बाईपास करने के लिए डायरेक्ट वैलिडेशन भाई)
  String? _emailError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // 🎯 कड़क वैलिडेशन और पासवर्ड रीसेट लॉजिक भाई
  void handleReset() async {
    setState(() {
      _emailError = null;
    });

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _emailError = 'कृपया अपना ईमेल एड्रेस दर्ज करें भाई';
      });
      return;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _emailError = 'कृपया एक सही ईमेल एड्रेस डालें भाई';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 🔥 फायरबेस/बैकएंड के रीसेट पासवर्ड फंक्शन को कॉल किया भाई
    final result = await ref.read(authRepositoryProvider).sendPasswordResetEmail(email: email);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result == 'SUCCESS') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 रीसेट लिंक भेज दिया गया है! अपना ईमेल चेक करें भाई। 🚀'),
          backgroundColor: Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/login'); // लिंक भेजने के बाद वापस चमकदार नियॉन लॉगिन पर भेज दो भाई
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
    // 🎨 प्रीमियम डार्क नियॉन कलर्स भाई (K1 Club, Login, और Signup से 100% परफेक्ट मैचिंग)
    const neonCyan = Color(0xFF00E5FF);
    const neonGreen = Color(0xFF00FF9F);
    const darkBackground = Color(0xFF0F172A); // गहरा स्पेस लक्ज़री ब्लू-ब्लैक
    const cardColor = Color(0xFF1E293B);      // प्रीमियम कार्ड सरफेस
    const borderTextColor = Color(0xFF334155);

    return Scaffold(
      backgroundColor: darkBackground,
      // 🔙 वापस जाने के लिए एक प्रीमियम कस्टमाइज्ड बैक बटन जो थीम से मैच करे
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420), // वेब रिस्पॉन्सिवनेस
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
                  // 🚀 की-लॉक का सुंदर प्रीमियम नियॉन आइकॉन भाई
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: neonCyan.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_outlined,
                        color: neonCyan,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 🔥 हेडिंग्स
                  const Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Enter your email and we will send you a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
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
                    keyboardType: TextInputType.text, // 👈 क्रोम को चकमा देने की मास्टर चाबी भाई!
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    decoration: InputDecoration(
                      errorText: _emailError,
                      prefixIcon: const Icon(Icons.email_outlined, color: neonCyan, size: 20),
                      hintText: 'Enter your registered email',
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

                  // 🩵 नियॉन सियान कड़क रीसेट बटन
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
                      onPressed: _isLoading ? null : handleReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neonCyan,
                        foregroundColor: const Color(0xFF06111C), // बटन पर कड़क डार्क टेक्स्ट
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
                              'SEND RESET LINK',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 🔄 वापस लॉगिन पर जाने का लिंक भाई (नियॉन ग्रीन हाइलाइट)
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(foregroundColor: neonCyan),
                      child: RichText(
                        text: TextSpan(
                          text: 'Remembered your password? ',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                          children: const [
                            TextSpan(
                              text: 'Back to Login',
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