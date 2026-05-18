import 'package:tao_boost/core/network/network_exceptions.dart';
import 'package:tao_boost/core/network/api_client.dart'; // FIX: ApiClient का इम्पोर्ट अब बिल्कुल सही है
import '../datasources/auth_remote_data_source.dart'; // FIX: आपके नए 'datasources' फोल्डर का सटीक रिलेटिव पाथ

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userData = await _remoteDataSource.login(email: email, password: password);
      return userData;
    } on NetworkException catch (e) {
      throw e.message;
    } catch (e) {
      throw "लॉगिन करने में विफलता (Something went wrong during login)";
    }
  }
}