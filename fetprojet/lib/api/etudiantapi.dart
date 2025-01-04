import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EtudiantApi {
  // Base URL static pour permettre l'accès dans les méthodes statiques
  static String get baseUrl {
    final baseUrll = dotenv.get('API_BASE_URL', fallback: '');
    if (baseUrll.isEmpty) {
      throw Exception('API_BASE_URL is not set in .env file');
    }
    return '$baseUrll/admin/session/672d087f98441d6263ce563a/departments/4fb595c5-da9b-42ed-8781-92594760b71c/groups/e7127c18-7ca0-47fc-a881-241d4345d9f7/students';
  }

  static Future<List<Map<String, dynamic>>> getStudents() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load students: ${response.reasonPhrase}');
    }
  }

  static Future<void> addStudent(Map<String, dynamic> studentData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(studentData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add student: ${response.reasonPhrase}');
    }
  }
// uplode student file
  static Future<void> uploadFile(http.MultipartFile file) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(file);

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload file: ${response.reasonPhrase}');
    }
  }
// update
  static Future<void> updateStudent(String id, Map<String, dynamic> studentData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(studentData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update student: ${response.reasonPhrase}');
    }
  }
// delete student
  static Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete student: ${response.reasonPhrase}');
    }
  }

// get student par id 
  static Future<Map<String, dynamic>> getStudent(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch student details: ${response.reasonPhrase}');
    }
  }
}
