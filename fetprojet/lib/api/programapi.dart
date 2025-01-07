import 'dart:convert';
import 'package:fetprojet/dtoprogram.dart';
import 'package:http/http.dart' as http;

class ProgramApi {
  final String baseUrl;

  ProgramApi({required this.baseUrl});

 Future<bool> addProgramToGroup({
  required String sessionId,
  required String departmentId,
  required String groupId,
  required ProgramDto programDto,  // Accept ProgramDto as a parameter
}) async {
  final url =
      "$baseUrl/admin/session/$sessionId/department/$departmentId/group/$groupId";

  // Structure du corps de la requête
  final body = json.encode({
    "programName": programDto.programName,
    "subjects": programDto.subjects.map((programSubject) {
      return {
        "subject": {
          "subjectName": programSubject.subject.subjectName,
          "duration": programSubject.subject.duration,
        },
        "recurrence": programSubject.recurrence,
      };
    }).toList(),
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Failed to add program: ${response.body}");
      return false;
    }
  } catch (error) {
    print("Error adding program: $error");
    return false;
  }
}



  // Récupérer le programme d'un groupe
  Future<Map<String, dynamic>?> getGroupProgram({
    required String sessionId,
    required String departmentId,
    required String groupId,
  }) async {
    final url =
        "$baseUrl/admin/session/$sessionId/department/$departmentId/group/$groupId";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to get group program: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error fetching group program: $error");
      return null;
    }
  }

  // Supprimer un programme d'un groupe
  Future<bool> deleteGroupProgram({
    required String sessionId,
    required String departmentId,
    required String groupId,
  }) async {
    final url =
        "$baseUrl/admin/session/$sessionId/department/$departmentId/group/$groupId";

    try {
      final response = await http.delete(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete group program: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error deleting group program: $error");
      return false;
    }
  }
}
