import 'dart:convert';
import 'package:fetprojet/pages/prof/Subject.dart';
import 'package:http/http.dart' as http;

import 'package:fetprojet/pages/prof/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Teacherapi {
 Future<Teacher> getTeacherById() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? sessionID = prefs.getString('sessionList');
    final String? idUser = prefs.getString('idUser');

    final url = 'http://10.0.2.2:8081/admin/session/$sessionID/teacher/$idUser';
    final response = await http.get(Uri.parse(url));

    print("________getTeacherById Response Start_________");
    print(response.body);
    print("________getTeacherById Response End___________");
print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Ajout d'une liste vide si subjectsCanTeach est null
      jsonResponse['subjectsCanTeach'] ??= [];
print("techer from jsonnnnnnnnnnn ");
print(Teacher.fromJson(jsonResponse));
      return Teacher.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load Teacher (Status Code: ${response.statusCode})');
    }
  } catch (e) {
    throw Exception('getTeacherById Error fetching Teacher by ID: $e');
  }
}

  Future<List<Subject>> getallSubject() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? sessionID = prefs.getString('sessionList');
      final url = "http://10.0.2.2:8081/admin/session/$sessionID/subjects";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> subjectsJson = json.decode(response.body);
        return subjectsJson.map((json) => Subject.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Subjects');
      }
    } catch (e) {
      throw Exception('Error fetching Subjects: $e');
    }
  }

  Future<Map<String, dynamic>> getTimetable( String name) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? sessionID = prefs.getString('sessionList');
      final url =
          "http://10.0.2.2:5000/get-timetable-by-teacher-and-session?teacherName=$name&sessionId=$sessionID";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load timetable');
      }
    } catch (e) {
      throw Exception('Error fetching timetable: $e');
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? sessionID = prefs.getString('sessionList');
      final url =
          'http://10.0.2.2:8081/admin/session/$sessionID/teacher/${teacher.id}';

      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(teacher.toJson()),
      );

      if (response.statusCode == 200) {
        print('Teacher updated successfully');
      } else {
        throw Exception('Failed to update Teacher: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating teacher: $e');
      throw Exception('Error updating Teacher: $e');
    }
  }
}
