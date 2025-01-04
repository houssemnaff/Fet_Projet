import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL from environment variables
  String get baseUrl => dotenv.get('API_BASE_URL');

  // Add a new session
 Future<http.Response?> addSession(Map<String, dynamic> sessionData) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/sessions'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(sessionData),
    );

    // Retourne directement la réponse
    return response;
  } catch (e) {
    print("Error: $e");
    return null; // En cas d'erreur, retourner null
  }
}


  // Fetch available sessions (this will give a list of all sessions)
  Future<List<Map<String, dynamic>>> fetchSessions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/sessions'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load sessions');
      }
    } catch (e) {
      throw Exception('Failed to load sessions: $e');
    }
  }

  // Fetch session details by session ID
  Future<Map<String, dynamic>> fetchSessionDetails(String sessionId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/sessions/$sessionId'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the session details
      } else {
        throw Exception('Failed to load session details');
      }
    } catch (e) {
      throw Exception('Failed to load session details: $e');
    }
  }




Future<http.Response?> updateUserRolesAndSessions(
    String userId, String roleUser, List<String> sessionList) async {


  try {
    final response = await http.put(
      Uri.parse('$baseUrl/roles/update/$userId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "roleUser": roleUser,
        "sessionList": sessionList,
      }),
    );

    return response; // Retourner la réponse HTTP
  } catch (e) {
    print("Error: $e");
    return null; // Retourner null en cas d'erreur
  }
}


  
}
