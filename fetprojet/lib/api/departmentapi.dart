import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class departmentapi {
 // final String baseUrl = "http://localhost:8081";
  final String baseUrl =  'http://10.0.2.2:8081';

  // Add a department to a session
  Future<http.Response> addDepartmentToSession(
      String sessionId, String departmentName) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/department');
    final body = jsonEncode({
      "departmentName": departmentName,
    });
    final headers = {'Content-Type': 'application/json'};

    return await http.post(url, body: body, headers: headers);
  }

  // Get all departments for a session
  Future<http.Response> getAllDepartments(String sessionId) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/departments');
    return await http.get(url);
  }

  // Get a department by its ID
  Future<http.Response> getDepartmentById(String sessionId, String depId) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/department/$depId');
    return await http.get(url);
  }

  // Delete a department by its ID
  Future<http.Response> deleteDepartment(
      String sessionId, String depId) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/department/$depId');
    return await http.delete(url);
  }

  // Update a department by its ID
  Future<http.Response> updateDepartment(
      String sessionId, String depId, String newDepartmentName) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/department/$depId');
    final body = jsonEncode({
      "departmentName": newDepartmentName,
    });
    final headers = {'Content-Type': 'application/json'};

    return await http.put(url, body: body, headers: headers);
  }
}
