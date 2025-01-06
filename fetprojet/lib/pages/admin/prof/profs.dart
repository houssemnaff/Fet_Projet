import 'package:fetprojet/components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Teacher {
  final int id;
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

  // Factory method to create a Teacher object from JSON
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      cin: json['cin'],
      email: json['email'],
      status: json['status'],
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
  bool isLoading = true; // To track loading state
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _cin = '';
  String _email = '';
  bool _isActive = true;

  // Function to fetch teachers from API
  Future<void> _fetchTeachers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('sessionId');

      if (sessionId == null || sessionId.isEmpty) {
        setState(() {
          errorMessage = 'Session ID not found!';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8081/admin/session/$sessionId/teachers'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> teacherData = json.decode(response.body);
        setState(() {
          teachers = teacherData.map((data) => Teacher.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to fetch teachers: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  void _addTeacher() {
    _name = '';
    _cin = '';
    _email = '';
    _isActive = true;

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
                  onChanged: (value) => _name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'CIN'),
                  onChanged: (value) => _cin = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a CIN';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) => _email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$",
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value!;
                        });
                      },
                    ),
                    const Text('Active'),
                    Radio(
                      value: false,
                      groupValue: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value!;
                        });
                      },
                    ),
                    const Text('Inactive'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    teachers.add(Teacher(
                      id: teachers.length + 1,
                      name: _name,
                      cin: _cin,
                      email: _email,
                      status: _isActive ? 'Active' : 'Inactive',
                    ));
                  });
                  Navigator.of(context).pop();
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Insertion Completed Successfully!',
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Teachers'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width),
                        child: DataTable(
                          columnSpacing: 20.0,
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: teachers.map((teacher) {
                            return DataRow(cells: [
                              DataCell(Text(teacher.id.toString())),
                              DataCell(Text(teacher.name)),
                              DataCell(
                                Text(
                                  teacher.status,
                                  style: TextStyle(
                                    color: teacher.status == 'Active'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.green, size: 20),
                                    onPressed: () {
                                      // Edit functionality here
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red, size: 20),
                                    onPressed: () {
                                      // Delete functionality here
                                    },
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Teachers'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 40), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            _addTeacher();
          }
        },
      ),
    );
  }
}
