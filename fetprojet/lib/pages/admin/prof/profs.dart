import 'dart:io';
import 'package:fetprojet/pages/prof/EditprofileTeacher.dart';
import 'package:fetprojet/pages/prof/TeacherhomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fetprojet/api/profapi.dart';
import 'package:fetprojet/components/drawer.dart';

class Teacher {
  final String id;
  final String name;
  final String cin;
  final String email;
  final String status;

  Teacher({
    required this.id,
    required this.name,
    required this.cin,
    required this.email,
    required this.status,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? 'N/A',
      name: json['teacherName'] ?? 'Unknown',
      cin: json['cin']?.toString() ?? 'N/A',
      email: json['email'] ?? 'N/A',
      status: json['valide'] == true ? 'Active' : 'Inactive',
    );
  }
}

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  List<Teacher> teachers = [];
  bool isLoading = true;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _cin = '';
  String _email = '';
  bool _isActive = true;

  Future<void> _fetchTeachers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
      List<dynamic> teacherData = await profapi().getAllTeachers(sessionId);

      setState(() {
        teachers = teacherData.map((data) => Teacher.fromJson(data)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteTeacher(String teacherId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
      // Call the API function to delete the teacher
      await profapi().deleteprof(sessionId, teacherId);

      // Fetch the updated list of teachers
      _fetchTeachers();

      // Show success alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Teacher deleted successfully!',
      );
    } catch (e) {
      // Show error alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to delete teacher: $e',
      );
    }
  }

  // Fonction pour ajouter un professeur avec validation
Future<void> _addTeacher() async {
  // Validation des champs
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
    // Call the API function to add teacher and capture the response
    String responseMessage = await profapi().addprofToSessionWithBody(sessionId, _name, _email, _cin);

    // Check if the response is successful
    if (responseMessage.contains("successfully")) {
      // Success alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: responseMessage,  // Display server response here
        onConfirmBtnTap: () {
          Navigator.of(context).pop(); // Close the dialog and return to the previous page
        },
      );

      // Optionally, update the teacher list
      _fetchTeachers();
    } else {
      // Error alert for failure
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: responseMessage,  // Display server response here
        onConfirmBtnTap: () {
          Navigator.of(context).pop(); // Close the dialog in case of error
        },
      );
    }
  } catch (e) {
    // Display the error in the alert if an exception occurs
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: 'Failed to add teacher: $e',  // Handle network or API errors
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Close the dialog in case of an exception
      },
    );
  }
}

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: const DrawerPage(),
    appBar: AppBar(
      title: const Text('Teachers'),
      centerTitle: true,
      backgroundColor: Colors.blue,
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : teachers.isEmpty
                ? const Center(child: Text('No teachers available'))
                : ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = teachers[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
  leading: CircleAvatar(
    backgroundColor: Colors.blue,
    child: Text(
      teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : '?',
      style: const TextStyle(color: Colors.white),
    ),
  ),
  title: Text(teacher.name),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("CIN: ${teacher.cin}"),
      Text("Email: ${teacher.email}"),
      Text("Status: ${teacher.status}"),
    ],
  ),
  trailing: IconButton(
    icon: const Icon(Icons.delete, color: Colors.red),
    onPressed: () => _deleteTeacher(teacher.id),
  ),
  onTap: () async {
    // Save teacher ID to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
          String sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";

    await prefs.setString('sessionList', sessionId);
    await prefs.setString("idUser", teacher.id);

    // Navigate to EditProfileTeacher
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Teacherhomepage()),
    );
  },
)

                      );
                    },
                  ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add New Teacher'),
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
                      _addTeacher();
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