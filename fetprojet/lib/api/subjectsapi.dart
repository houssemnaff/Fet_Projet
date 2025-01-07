import 'dart:convert';
import 'package:http/http.dart' as http;

// Subject model
class Subject {
  final String subjectId;
  final String name;
  final String duration;
  final String type;

  Subject({
    required this.subjectId,
    required this.name,
    required this.duration,
    required this.type,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectId: json['id'] ?? '',
      name: json['subjectName'] ?? '',
      duration: json['duration'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': subjectId,
      'subjectName': name,
      'duration': duration,
      'type': type,
    };
  }
}

// Subjects API
class SubjectsApi {
  final String baseUrl = 'http://10.0.2.2:8081';

  // Get all subjects
  Future<List<Subject>> getSubjects(String sessionId) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/subjects');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Subject.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  // Get a subject by ID
  Future<Subject> getSubjectById(String sessionId, String subjectId) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/subject/$subjectId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Subject.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load subject');
    }
  }

  // Add a subject
  Future<String> addSubject(String sessionId, Subject subject) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/subjects');

    // Get all subjects to check if the name exists
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      List<Subject> subjects = data.map((item) => Subject.fromJson(item)).toList();

      // Check if the subject with the same name already exists
      bool subjectExists = subjects.any((existingSubject) =>
          existingSubject.name.toLowerCase() == subject.name.toLowerCase());

      if (subjectExists) {
        return 'Subject with the same name already exists in the session';
      }

      // If subject does not exist, proceed to add it
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode(subject.toJson());

      final postResponse = await http.post(url, headers: headers, body: body);

      if (postResponse.statusCode == 201) {
        return 'Subject added successfully';
      } else {
        return 'Failed to add subject';
      }
    } else {
      return 'Failed to load subjects for comparison';
    }
  }

  // Update a subject
  Future<String> updateSubject(String sessionId, String subjectId, Subject subject) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/subject/$subjectId');

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(subject.toJson());

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return 'Subject updated successfully';
    } else {
      return 'Failed to update subject';
    }
  }

  // Delete a subject
  Future<String> deleteSubject(String sessionId, String subjectId) async {
    final url = Uri.parse('$baseUrl/admin/session/$sessionId/subject/$subjectId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return 'Subject deleted successfully';
    } else {
      return 'Failed to delete subject';
    }
  }
}
