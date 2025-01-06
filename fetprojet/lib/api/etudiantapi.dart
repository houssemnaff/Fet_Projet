import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EtudiantApi {
  final String baseUrl =  'http://10.0.2.2:8081';
  //String baseUrl = "http://localhost:8081/admin";

  // Ajouter un étudiant avec fichier
  Future<String> addStudentToGroupWithFile(String sessionId, String departmentId, String groupId, File studentFile) async {
    try {
      // Définir l'URL pour le point de terminaison de téléchargement du fichier
      var uri = Uri.parse(
        '$baseUrl/admin/session/$sessionId/departments/$departmentId/groups/$groupId/students/upload',
      );

      // Créer une MultipartRequest pour gérer le téléchargement du fichier
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', studentFile.path));

      // Envoyer la requête
      var response = await request.send();

      // Lire le corps de la réponse
      String responseBody = await response.stream.bytesToString();

      // Vérifier si le statut de la réponse est 200 (succès)
      if (response.statusCode == 200) {
        print('Student added to group successfully!');
        return responseBody; // Retourner le corps de la réponse en cas de succès
      } else {
        print('Failed to add student to group: ${response.statusCode}');
        return 'Failed to add student: ${response.statusCode}'; // Retourner le message d'échec
      }
    } catch (e) {
      print('Error occurred: $e');
      return 'Error occurred: $e'; // Retourner le message d'erreur
    }
  }

  // Supprimer un étudiant d'un groupe
  Future<String> deleteStudentFromGroup(String sessionId, String departmentId, String groupId, String studentId) async {
    try {
      // Définir l'URL pour le point de terminaison de suppression de l'étudiant
      var uri = Uri.parse(
        '$baseUrl/admin/session/$sessionId/departments/$departmentId/groups/$groupId/students/$studentId',
      );

      // Envoyer une requête HTTP DELETE
      var response = await http.delete(uri);

      // Vérifier si la réponse a un statut 200 (succès)
      if (response.statusCode == 200) {
        print('Student deleted from group successfully!');
        return 'Student deleted successfully'; // Retourner un message de succès
      } else {
        print('Failed to delete student: ${response.statusCode}');
        return 'Failed to delete student: ${response.statusCode}'; // Retourner un message d'échec
      }
    } catch (e) {
      print('Error occurred: $e');
      return 'Error occurred: $e'; // Retourner le message d'erreur
    }
  }
}
