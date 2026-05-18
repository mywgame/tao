import 'package:dio/dio.dart';
import 'network_exceptions.dart'; // FIX: नेटवर्क एक्सेप्शन का इम्पोर्ट जोड़ा

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options
      ..baseUrl = 'http://localhost:3000/api'
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..responseType = ResponseType.json;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🌐 API Request: [${options.method}] ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: [${response.statusCode}] ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ API Error: [${e.response?.statusCode}] ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // FIX: यहाँ ब्रैकेट और टाइप एकदम सही कर दिए गए हैं
  Exception _handleDioError(DioException e) {
    return NetworkException.fromDioError(e);
  }
} // FIX: आखिरी क्लोजिंग ब्रैकेट यहाँ फिक्स कर दिया