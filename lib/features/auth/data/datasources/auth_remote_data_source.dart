import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // ⏳ असली API कॉल को अभी कमेंट कर देते हैं ताकि टेस्ट कर सकें
    /*
    final response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
    */

    // 🚀 FAKE SUCCESS RESPONSE: टेस्ट करने के लिए 1 सेकंड का डिले और नकली डेटा
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'status': 'success',
      'token': 'mock_jwt_token_for_tao_boost_12345',
      'user': {
        'email': email,
        'name': 'TAO Investor',
      }
    };
  }
}