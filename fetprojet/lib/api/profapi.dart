import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class profapi {
  final String baseUrl =  'http://10.0.2.2:8081';
  //String baseUrl = "http://localhost:8081/admin";

  // Ajouter un étudiant avec fichier
  Future<String> addprofTosessionWithFile(String sessionId,  File proffile) async {
    try {
      // Définir l'URL pour le point de terminaison de téléchargement du fichier
      var uri = Uri.parse(
        '$baseUrl/admin/session/$sessionId/teachers/upload',
      );

      // Créer une MultipartRequest pour gérer le téléchargement du fichier
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', proffile.path));

      // Envoyer la requête
      var response = await request.send();

      // Lire le corps de la réponse
      String responseBody = await response.stream.bytesToString();

      // Vérifier si le statut de la réponse est 200 (succès)
      if (response.statusCode == 200) {
        print('prof added to session successfully!');
        return responseBody; // Retourner le corps de la réponse en cas de succès
      } else {
        print('Failed to add prof to session: ${response.statusCode}');
        return 'Failed to add prof: ${response.statusCode}'; // Retourner le message d'échec
      }
    } catch (e) {
      print('Error occurred: $e');
      return 'Error occurred: $e'; // Retourner le message d'erreur
    }
  }

  // Supprimer un étudiant d'un groupe
  Future<String> deleteprof(String sessionId,  String profid) async {
    try {
      // Définir l'URL pour le point de terminaison de suppression de l'étudiant
      var uri = Uri.parse(
        '$baseUrl/admin/session/$sessionId/teacher/$profid',
      );

      // Envoyer une requête HTTP DELETE
      var response = await http.delete(uri);

      // Vérifier si la réponse a un statut 200 (succès)
      if (response.statusCode == 200) {
        print('prof deleted from group successfully!');
        return 'prof deleted successfully'; // Retourner un message de succès
      } else {
        print('Failed to delete prof: ${response.statusCode}');
        return 'Failed to delete prof: ${response.statusCode}'; // Retourner un message d'échec
      }
    } catch (e) {
      print('Error occurred: $e');
      return 'Error occurred: $e'; // Retourner le message d'erreur
    }
  }
  // Récupérer tous les enseignants d'une session
  Future<List<dynamic>> getAllTeachers(String sessionId) async {
    try {
      // Définir l'URL pour récupérer les enseignants
      var uri = Uri.parse(
        '$baseUrl/admin/session/$sessionId/teachers',
      );

      // Envoyer une requête HTTP GET
      var response = await http.get(uri);

      // Vérifier si le statut de la réponse est 200 (succès)
      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        List<dynamic> teachers = json.decode(response.body);
        print('Teachers fetched successfully!');
        return teachers; // Retourner la liste des enseignants
      } else {
        print('Failed to fetch teachers: ${response.statusCode}');
        return []; // Retourner une liste vide en cas d'échec
      }
    } catch (e) {
      print('Error occurred while fetching teachers: $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }





  // Ajouter un professeur avec un body JSON
 Future<String> addprofToSessionWithBody(
    String sessionId, String teacherName, String email, String cin) async {
  try {
    // Définir l'URL pour ajouter un professeur
    var uri = Uri.parse('$baseUrl/admin/session/$sessionId/teachers');

    // Créer le body de la requête
    Map<String, String> body = {
      "teacherName": teacherName,
      "email": email,
      "cin": cin,
    };

    // Envoyer une requête HTTP POST
    var response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    );

    // Vérifier si le statut de la réponse est 200 (succès)
    if (response.statusCode == 200) {
      print('Teacher added successfully!');
      return 'Teacher added successfully'; // Retourner un message de succès
    } else if (response.statusCode == 409) {
      // Handle conflict error (teacher already exists)
      print('Teacher already exists: ${response.body}');
      return 'Teacher with the same email, CIN, or name already exists.'; // Return conflict message
    } else {
      // Handle other errors
      print('Failed to add teacher: ${response.statusCode} - ${response.body}');
      return 'Failed to add teacher: ${response.statusCode} - ${response.body}'; // Return failure message
    }
  } catch (e) {
    print('Error occurred while adding teacher: $e');
    return 'Error occurred: $e'; // Return error message
  }
}
}



