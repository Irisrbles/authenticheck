import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('http://localhost:3000/api/login'); // Change to your server IP if needed
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
  }
}

Future<Map<String, dynamic>> register({
  required String fullName,
  required String school,
  required String course,
  required int yearGraduated,
  required String email,
  required String diploma,
  required String password,
}) async {
  final url = Uri.parse('http://localhost:3000/api/register'); // Change to your server IP if needed
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'fullName': fullName,
      'school': school,
      'course': course,
      'yearGraduated': yearGraduated,
      'email': email,
      'diploma': diploma,
      'password': password,
    }),
  );
  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Registration failed');
  }
}

Future<Map<String, dynamic>> sendOtp(String email) async {
  final url = Uri.parse('http://localhost:3000/api/forgot-password');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to send OTP');
  }
}

Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
  final url = Uri.parse('http://localhost:3000/api/verify-otp');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body)['message'] ?? 'OTP verification failed');
  }
}

Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
  final url = Uri.parse('http://localhost:3000/api/reset-password');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'newPassword': newPassword}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Password reset failed');
  }
}

Future<Map<String, dynamic>> changePassword({
  required String email,
  required String currentPassword,
  required String newPassword,
}) async {
  final url = Uri.parse('http://localhost:3000/api/change-password');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    }),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body)['message'] ?? 'Change password failed');
  }
}