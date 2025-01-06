import 'package:fetprojet/api/departmentapi.dart';
import 'package:fetprojet/api/groupsapi.dart';
import 'package:flutter/material.dart';
import 'package:fetprojet/pages/admin/prof/telechargerprof.dart';
import 'package:fetprojet/pages/admin/etudiant/uplodfileetudiant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DepartmentClassPage extends StatefulWidget {
  const DepartmentClassPage({super.key});

  @override
  _DepartmentClassPageState createState() => _DepartmentClassPageState();
}

class _DepartmentClassPageState extends State<DepartmentClassPage> {
  List<Map<String, String>> _departments = [];
  String? selectedDepartment;
  TextEditingController classNameController = TextEditingController();
  TextEditingController nbrplace = TextEditingController();

  List<Map<String, String>> addedClasses = [];
  List<Map<String, dynamic>> groups = [];
  final departmentapi _depApi = departmentapi();
  final classapi _classApi = classapi();

  @override
  void initState() {
    super.initState();
    getAllDepartmentsBySession();
  }

  Future<void> getAllDepartmentsBySession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";

      if (sessionId.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Session ID not found. Please try again.',
        );
        return;
      }

      final response = await _depApi.getAllDepartments(sessionId);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _departments.clear();
          _departments.addAll(data.map<Map<String, String>>((item) {
            return {
              "departmentId": item['departmentId'].toString(),
              "departmentName": item['departmentName'].toString(),
            };
          }).toList());
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

  Future<void> fetchGroups() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString('sessionId') ?? '6767ed5018e2bd7ea42682c7';
      
      if (selectedDepartment == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Please select a department.',
        );
        return;
      }

      final response = await _classApi.fetchGroupsByDepartment(sessionId, selectedDepartment!);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          groups.clear();
          groups.addAll(data.map<Map<String, dynamic>>((group) {
            return {
              "groupId": group['groupId'].toString(),
              "groupName": group['groupName'].toString(),
              "numberGroups": group['numberGroups'], 
            };
          }).toList());
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

 Future<void> addClass() async {
  if (selectedDepartment != null && classNameController.text.isNotEmpty && nbrplace.text.isNotEmpty) {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString('sessionId') ?? '6767ed5018e2bd7ea42682c7';
      String departmentId = selectedDepartment!;
      String groupName = classNameController.text;
      int numberGroups = int.parse(nbrplace.text); 

      final response = await _classApi.createGroup(sessionId, departmentId, groupName, numberGroups);

      if (response.statusCode == 200) {
        // Clear the input fields
        classNameController.clear();
        nbrplace.clear();

        // Call fetchGroups to refresh the list of groups
        await fetchGroups();

        // Clear the selected department
        setState(() {
          selectedDepartment = null;
        });

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Class successfully added.',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to add the class. Please try again.',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred while adding the class: $e',
      );
    }
  } else {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'Please select a department, enter a class name, and provide the number of places.',
    );
  }
}
  // Function to delete class
  Future<void> deleteClass(String groupId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString('sessionId') ?? '6767ed5018e2bd7ea42682c7';

      final response = await _classApi.deleteClass(sessionId, selectedDepartment!, groupId);

      if (response.statusCode == 200) {
        // Successfully deleted
        fetchGroups(); // Refresh the groups
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Group deleted successfully.',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to delete the group. Please try again.',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred while deleting the group: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Enregistrement des classes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Sélectionnez un département et enregistrez une classe',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selectedDepartment,
                hint: const Text('Sélectionner un Département'),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                  fetchGroups();  // Call fetchGroups when a department is selected
                },
                items: _departments.map((department) {
                  return DropdownMenuItem(
                    value: department['departmentId'],
                    child: Text(department['departmentName']!),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: classNameController,
                decoration: const InputDecoration(labelText: 'Nom de la classe'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nbrplace,
                decoration: const InputDecoration(labelText: 'Nombre de places'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: addClass,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Enregistrer la classe'),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Groupes existants:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  title: Text(group['groupName'] ?? ''),
                  subtitle: Text('Places disponibles: ${group['numberGroups']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Call deleteClass function
                      deleteClass(group['groupId']);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
