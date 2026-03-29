

import 'package:dio/dio.dart';

class ApiService {
 final  Dio _dio = Dio();
  
  Future<Response>post({required  body, required String url, required String token,String? contentType}) async {
    try {
      final response = await _dio.post(
        url, data: body, options: Options(headers: {'Authorization': 'Bearer $token'}, contentType: contentType));
      return response;
    } catch (e) {
      rethrow;
    }
  }

}