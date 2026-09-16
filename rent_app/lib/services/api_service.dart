import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
    }) async {
        final response = await http.post(
            Uri.parse('$baseUrl/api/auth/login'),
            headers: {
                'Content-Type': 'application/json',
                },
                body: jsonEncode({
                    'phone': phone,
                    'password': password,
                }),
            );

            if (response.statusCode == 200) {
                return jsonDecode(response.body);
         }

        throw Exception('Login failed');
    }

  // -------------------------
  // TENANT
  // -------------------------

  static Future<Map<String, dynamic>> getTenantDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tenant/dashboard'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Failed to load dashboard: ${response.statusCode}',
    );
  }

  // -------------------------
  // LANDLORD - PAYMENT
  // -------------------------

  static Future<void> updatePayment({
    required String month,
    required int year,
    required double rent,
    required double electricity,
    required String paymentDate,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/landlord/payment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'month': month,
        'year': year,
        'rent': rent,
        'electricity': electricity,
        'total': rent + electricity,
        'paymentDate': paymentDate,
        'status': status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update payment');
    }
  }

  // -------------------------
  // LANDLORD - ELECTRICITY
  // -------------------------

  static Future<void> updateElectricity({
    required String name,
    required String status,
    required String note,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/landlord/electricity'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'status': status,
        'note': note,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update electricity status');
    }
  }

  // -------------------------
  // LANDLORD - WATER
  // -------------------------

  static Future<void> updateWater({
    required String status,
    required String note,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/landlord/water'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status,
        'note': note,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update water status');
    }
  }
}