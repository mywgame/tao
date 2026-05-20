import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 🪙 FirebaseAuth की लाइव इंस्टेंस का प्रोवाइडर भाई
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// 2. 🔄 यूज़र के लाइव लॉगिन स्टेटस को ट्रैक करने वाला स्ट्रीम प्रोवाइडर
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// 3. 🧠 ऑथेंटिकेशन का असली काम (लॉगिन, साइनअप, लॉगआउट) संभालने वाली रिपोजिटरी क्लास
class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  // 📝 साइनअप (Create New Account) लॉजिक
  Future<String> signUpWithEmail({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return 'SUCCESS';
    } on FirebaseAuthException catch (e) {
      // 🛑 एरर्स को आसान और प्रोफेशनल टेक्स्ट में बदला भाई
      if (e.code == 'weak-password') return 'The password provided is too weak.';
      if (e.code == 'email-already-in-use') return 'An account already exists for this email.';
      if (e.code == 'invalid-email') return 'The email address is badly formatted.';
      return e.message ?? 'Registration failed. Please try again.';
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // 🔑 लॉगिन (Sign In) लॉजिक
  Future<String> signInWithEmail({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'SUCCESS';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return 'Invalid email or password. Please try again.';
      }
      if (e.code == 'invalid-email') return 'The email address is badly formatted.';
      if (e.code == 'user-disabled') return 'This user account has been disabled.';
      return e.message ?? 'Login failed. Please try again.';
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // 🔄 पासवर्ड रीसेट (Forgot Password) लिंक भेजना
  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'SUCCESS';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return 'No user found with this email.';
      if (e.code == 'invalid-email') return 'The email address is badly formatted.';
      return e.message ?? 'Failed to send reset email.';
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  // 🚪 लॉगआउट (Sign Out) लॉजिक
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// 4. 🌐 पूरी ऐप में इस्तेमाल के लिए Auth Repository का ग्लोबल प्रोवाइडर भाई
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});
   //