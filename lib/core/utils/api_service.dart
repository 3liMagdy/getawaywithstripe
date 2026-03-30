import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://robt-unkinglike-insipidly.ngrok-free.dev", 
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  Future<Response> post({
    required Object body,
    required String url,
    Map<String, String>? headers,
    String? contentType,
  }) async {
    try {
      final response = await _dio.post(
        url, 
        data: body,
        options: Options(
          headers: {
            ...?_dio.options.headers,
            ...?headers,
          },
          contentType: contentType,
        ),
      );
      return response;
    } on DioException catch (e) {
      print(" Dio Error: ${e.message}");
      print(" Response: ${e.response?.data}");
      rethrow;
    }
  }
}