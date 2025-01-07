import 'dart:convert';
import 'package:fetprojet/api/departmentapi.dart';
import 'package:fetprojet/api/etudiantapi.dart';
import 'package:fetprojet/api/groupsapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Etudiant {
  final String id;
  final String name;
  final String cin;
  final String email;

  Etudiant({
    required this.id,
    required this.name,
    required this.cin,
    required this.email,
  });
}

class EtudiantPage extends StatefulWidget {
  const EtudiantPage({Key? key}) : super(key: key);

  @override
  _EtudiantPageState createState() => _EtudiantPageState();
}

class _EtudiantPageState extends State<EtudiantPage> {
  final String baseUrl = 'http://10.0.2.2:8081'; // Remplacez par l'URL appropriée
  String? selectedDepartmentId;
  String? selectedGroupId;
  List<Map<String, String>> departments = [];
  List<Map<String, String>> groups = [];
  List<Etudiant> students = [];
  final classapi _classApi = classapi();
  final departmentapi _depApi = departmentapi();
  final EtudiantApi etapi = EtudiantApi();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();  // Form Key for validation
  String _name = '';
  String _cin = '';
  String _email = '';
  String _group = '';

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  // Fetch departments from the API
  Future<void> fetchDepartments() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
      final response = await _depApi.getAllDepartments(sessionId);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          departments = data.map<Map<String, String>>((item) {
            return {
              "departmentId": item['departmentId'].toString(),
              "departmentName": item['departmentName'].toString(),
            };
          }).toList();
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to load departments. Please try again.',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred: $e',
      );
    }
  }

  // Add student to the database
 Future<void> _addStudent() async {
  if (_cin.length != 8 || !_cin.contains(RegExp(r'^\d+$'))) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Invalid CIN',
      text: 'CIN must contain exactly 8 digits.',
    );
    return;
  }

  if (!_email.contains('@gmail.com')) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Invalid Email',
      text: 'Email must be a valid Gmail address.',
    );
    return;
  }

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
    
    // Ensure groupId is selected
    if (selectedDepartmentId != null && selectedGroupId != null) {
      String responseMessage = await etapi.addStudentWithBody(
        sessionId, 
        selectedDepartmentId!, 
        selectedGroupId!, 
        _name, 
        _email, 
        _cin, 
        _group
      );

      if (responseMessage.contains("successfully")) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: responseMessage,  // Display server response here
          onConfirmBtnTap: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
        fetchStudents(selectedGroupId!); // Refresh student list
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: responseMessage,  // Display server response here
          onConfirmBtnTap: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Department or Group not selected!',
      );
    }
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Failed to add student: $e',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Close the dialog
      },
    );
  }
}

  Future<void> deleteStudent(String studentId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd";
      if (sessionId != null && selectedDepartmentId != null && selectedGroupId != null) {
        final result = await etapi.deleteStudentFromGroup(sessionId, selectedDepartmentId!, selectedGroupId!, studentId);
        if (result == 'Student deleted successfully') {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Student deleted successfully!',
          );
          fetchStudents(selectedGroupId!); // Refresh the student list after deletion
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: result,
          );
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Session, Department, or Group not found.',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred while deleting student: $e',
      );
    }
  }

  // Fetch groups based on department
  Future<void> fetchGroups(String departmentId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
      final response = await _classApi.fetchGroupsByDepartment(sessionId, departmentId);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          groups = data.map<Map<String, String>>((group) {
            return {
              "groupId": group['groupId'].toString(),
              "groupName": group['groupName'].toString(),
            };
          }).toList();
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to fetch groups. Please try again.',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred while fetching groups: $e',
      );
    }
  }

  // Fetch students for a group
  Future<void> fetchStudents(String groupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionId');
      final departmentId = selectedDepartmentId;

      if (sessionId == null || departmentId == null) {
        print('Session ID or Department ID not found in SharedPreferences');
        return;
      }

      final response = await http.get(Uri.parse('$baseUrl/admin/session/$sessionId/departments/$departmentId/groups/$groupId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          students = (data['students'] as List).map((student) {
            return Etudiant(
              id: student['id'].toString(),
              name: student['name'].toString(),
              cin: student['cin'].toString(),
              email: student['email'].toString(),
            );
          }).toList();
        });
      } else {
        print('Failed to fetch students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Étudiants'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown pour sélectionner le département
            DropdownButton<String>(
              value: selectedDepartmentId,
              hint: const Text('Sélectionner le Département'),
              onChanged: (value) {
                setState(() {
                  selectedDepartmentId = value;
                  selectedGroupId = null; // Réinitialiser le groupe lors du changement de département
                  groups = []; // Réinitialiser les groupes
                  students = []; // Réinitialiser les étudiants
                });
                fetchGroups(value!); // Récupérer les groupes pour le département sélectionné
              },
              items: departments.map((department) {
                return DropdownMenuItem<String>(
                  value: department['departmentId'],
                  child: Text(department['departmentName']!),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Dropdown pour sélectionner le groupe
            if (selectedDepartmentId != null)
              DropdownButton<String>(
                value: selectedGroupId,
                hint: const Text('Sélectionner le Groupe'),
                onChanged: (value) {
                  setState(() {
                    selectedGroupId = value;
                  });
                  fetchStudents(value!); // Récupérer les étudiants pour le groupe sélectionné
                },
                items: groups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group['groupId'],
                    child: Text(group['groupName']!),
                  );
                }).toList(),
              ),

            const SizedBox(height: 16.0),

            // Liste des étudiants
            Expanded(
              child: students.isNotEmpty
                  ? ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(student.name),
                            subtitle: Text('CIN: ${student.cin}\nEmail: ${student.email}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteStudent(student.id); // Appeler la méthode de suppression
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(selectedGroupId == null
                          ? 'Veuillez sélectionner un groupe pour afficher les étudiants.'
                          : 'Aucun étudiant trouvé pour ce groupe.'), 
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add New Student'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        onSaved: (value) => _name = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'CIN'),
                        onSaved: (value) => _cin = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter CIN';
                          }
                          if (value.length != 8 || !RegExp(r'^\d+$').hasMatch(value)) {
                            return 'CIN must be 8 digits';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        onSaved: (value) => _email = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!value.contains('@gmail.com')) {
                            return 'Email must be a valid Gmail address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _addStudent();
                      }
                    },
                    child: const Text('Add'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
