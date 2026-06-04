import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'api_config.dart';

class ApiClient {
  static const String _tokenKey = 'auth_token';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final token = await _getToken();
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };
    return http.get(Uri.parse(ApiConfig.getApiUrl(endpoint)), headers: requestHeaders);
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final token = await _getToken();
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };
    return http.post(Uri.parse(ApiConfig.getApiUrl(endpoint)), headers: requestHeaders, body: jsonEncode(body));
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final token = await _getToken();
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };
    return http.put(Uri.parse(ApiConfig.getApiUrl(endpoint)), headers: requestHeaders, body: jsonEncode(body));
  }

  static Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    final token = await _getToken();
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };
    return http.delete(Uri.parse(ApiConfig.getApiUrl(endpoint)), headers: requestHeaders);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
