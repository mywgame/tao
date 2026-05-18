import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({required this.message, this.statusCode});

  @override
  String toString() => message;

  // Dio के एरर को पहचान कर कस्टम मैसेज देने वाला फ़ंक्शन
  factory NetworkException.fromDioError(DioException dioError) {
    String message = "अपरिचित त्रुटि (Unknown error occurred)";
    int? statusCode = dioError.response?.statusCode;

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        message = "कनेक्शन का समय समाप्त (Connection timeout with server)";
        break;
      case DioExceptionType.sendTimeout:
        message = "डेटा भेजने का समय समाप्त (Send timeout in association with server)";
        break;
      case DioExceptionType.receiveTimeout:
        message = "डेटा प्राप्त करने का समय समाप्त (Receive timeout in connection with server)";
        break;
      case DioExceptionType.connectionError:
        message = "इंटरनेट कनेक्शन की समस्या (No internet connection)";
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(statusCode, dioError.response?.data);
        break;
      case DioExceptionType.cancel:
        message = "अनुरोध रद्द कर दिया गया (Request to server was cancelled)";
        break;
      default:
        message = "कुछ गड़बड़ हुई है, कृपया दोबारा प्रयास करें।";
        break;
    }

    return NetworkException(message: message, statusCode: statusCode);
  }

  // स्टेटस कोड के हिसाब से मैसेज बदलने के लिए सहायक फ़ंक्शन
  static String _handleStatusCode(int? statusCode, dynamic errorData) {
    // अगर बैकएंड से कोई स्पेसिफिक मैसेज आ रहा है (NestJS अक्सर { message: "..." } भेजता है)
    if (errorData != null && errorData is Map && errorData['message'] != null) {
      if (errorData['message'] is List) {
        return (errorData['message'] as List).join(', ');
      }
      return errorData['message'].toString();
    }

    switch (statusCode) {
      case 400:
        return "गलत अनुरोध (Bad request. Please check your inputs).";
      case 401:
        return "सत्र समाप्त या अनधिकृत (Unauthorized. Please login again).";
      case 403:
        return "निषिद्ध अनुरोध (Forbidden access).";
      case 404:
        return "डेटा नहीं मिला (Requested resource not found).";
      case 500:
        return "सर्वर में आंतरिक त्रुटि (Internal server error. Try again later).";
      default:
        return "सर्वर से संपर्क नहीं हो पाया (Oops! Something went wrong).";
    }
  }
}