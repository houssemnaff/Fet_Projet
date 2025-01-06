import 'dart:convert';
import 'package:http/http.dart' as http;

class classapi {
  //String baseUrl = "http://localhost:8081/admin";
  final String baseUrl =  'http://10.0.2.2:8081';

  // Fonction pour créer un groupe
  Future<http.Response> createGroup(
    String sessionId,
    String departmentId,
    String groupName,
    int numberGroups,
  ) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/departments/$departmentId/groups');
    
    final headers = {
      'Content-Type': 'application/json', // Specifies that we are sending JSON data
    };

    final body = jsonEncode({
      'groupName': groupName,
      'numberGroups': numberGroups,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Success - handle success response here
        print('Group created successfully');
      } else if (response.statusCode == 400) {
        // Bad request, possibly invalid data
        print('Bad request: ${response.body}');
      } else if (response.statusCode == 500) {
        // Server error
        print('Server error: ${response.body}');
      } else {
        // Unexpected response code
        print('Unexpected error: ${response.statusCode}');
      }
      return response;
    } catch (e) {
      // Catch any exception that occurs during the request
      print('An error occurred: $e');
      rethrow;  // Optionally rethrow the error to be handled at a higher level
    }
  }

  // Fonction pour récupérer les groupes d'un département
  Future<http.Response> fetchGroupsByDepartment(String sessionId, String departmentId) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/departments/$departmentId/groups');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json', // Specifies that we are expecting JSON response
        },
      );

      // Vérification de la réponse
      if (response.statusCode == 200) {
        // Si la requête réussie, retourner la réponse
        print("Groups fetched successfully: ${response.body}");
      } else if (response.statusCode == 400) {
        // Requête incorrecte, données invalides
        print('Bad request: ${response.body}');
      } else if (response.statusCode == 404) {
        // Ressource non trouvée
        print('Department not found: ${response.body}');
      } else if (response.statusCode == 500) {
        // Erreur côté serveur
        print('Server error: ${response.body}');
      } else {
        // Code de statut non attendu
        print('Unexpected error: ${response.statusCode}');
      }
      return response;
    } catch (e) {
      // En cas d'erreur réseau ou autre
      print('An error occurred: $e');
      rethrow;  // Optionnel, permet de relancer l'erreur pour une gestion ultérieure
    }
  }

  // Fonction pour supprimer un groupe d'un département
  Future<http.Response> deleteClass(
    String sessionId,
    String departmentId,
    String groupId,
  ) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/departments/$departmentId/groups/$groupId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json', // Specifies that we are expecting JSON response
        },
      );

      // Vérification de la réponse
      if (response.statusCode == 200) {
        // Si la requête réussie, retourner la réponse
        print('Group deleted successfully');
      } else if (response.statusCode == 400) {
        // Requête incorrecte, données invalides
        print('Bad request: ${response.body}');
      } else if (response.statusCode == 404) {
        // Ressource non trouvée
        print('Group or Department not found: ${response.body}');
      } else if (response.statusCode == 500) {
        // Erreur côté serveur
        print('Server error: ${response.body}');
      } else {
        // Code de statut non attendu
        print('Unexpected error: ${response.statusCode}');
      }
      return response;
    } catch (e) {
      // En cas d'erreur réseau ou autre
      print('An error occurred: $e');
      rethrow;  // Optionnel, permet de relancer l'erreur pour une gestion ultérieure
    }
  }
}
