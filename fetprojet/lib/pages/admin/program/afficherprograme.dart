import 'dart:convert';

import 'package:fetprojet/api/departmentapi.dart';
import 'package:fetprojet/api/groupsapi.dart';
import 'package:fetprojet/api/programapi.dart';
import 'package:fetprojet/dtoprogram.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AfficheProgram extends StatefulWidget {
  const AfficheProgram({super.key});

  @override
  State<AfficheProgram> createState() => _AfficheProgramState();
}

class _AfficheProgramState extends State<AfficheProgram> {
  final departmentApi = departmentapi();
  final programApi = ProgramApi(baseUrl: 'http://10.0.2.2:8081');
  String? selectedDepartmentId;
  String? selectedGroupId;
  List<Map<String, String>> departments = [];
  List<Map<String, String>> groups = [];
  ProgramDto? programDetailss; // Change to ProgramDto type

  final classapi _classApi = classapi();
  final departmentapi _depApi = departmentapi();

  // Fetch departments
  Future<void> fetchDepartments() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId =
          prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
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

  // Fetch groups by department
  Future<void> fetchGroups(String departmentId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId =
          prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
      final response =
          await _classApi.fetchGroupsByDepartment(sessionId, departmentId);
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

  // Get group program
  Future<void> getGroupProgram({
    required String sessionId,
    required String departmentId,
    required String groupId,
  }) async {
    final url =
        "http://10.0.2.2:8081/admin/session/$sessionId/department/$departmentId/group/$groupId";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          programDetailss =
              ProgramDto.fromJson(data); // Assign the parsed ProgramDto object
        });
      } else {
        print("Failed to get group program: ${response.body}");
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to load group program.',
        );
      }
    } catch (error) {
      print("Error fetching group program: $error");
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred: $error',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDepartments(); // Fetch departments when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Department and Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Department Dropdown
            DropdownButton<String>(
              value: selectedDepartmentId,
              hint: const Text('Select Department'),
              onChanged: (value) {
                setState(() {
                  selectedDepartmentId = value;
                  selectedGroupId = null; // Reset group when department changes
                });
                fetchGroups(value!); // Fetch groups for selected department
              },
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              iconEnabledColor: Colors.blueAccent,
              underline: Container(),
              dropdownColor: Colors.white,
              isExpanded: true,
              items: departments.map((department) {
                return DropdownMenuItem(
                  value: department['departmentId'],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: Text(
                      department['departmentName']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Group Dropdown (only shows if a department is selected)
            if (selectedDepartmentId != null)
              DropdownButton<String>(
                value: selectedGroupId,
                hint: const Text('Select Group'),
                onChanged: (value) async {
                  setState(() {
                    selectedGroupId = value;
                  });
                  // Fetch the program when a group is selected
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String sessionId = prefs.getString("sessionId") ??
                      "6767ed5018e2bd7ea42682c7";
                  getGroupProgram(
                    sessionId: sessionId,
                    departmentId: selectedDepartmentId!,
                    groupId: value!,
                  );
                },
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                iconEnabledColor: Colors.blueAccent,
                underline: Container(),
                dropdownColor: Colors.white,
                isExpanded: true,
                items: groups.map((group) {
                  return DropdownMenuItem(
                    value: group['groupId'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        group['groupName']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),

            // Display the Program Details (if available)
            if (programDetailss != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Program Name
                            Text(
                              'Program: ${programDetailss!.programName}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Subjects Section
                            const Text(
                              'Subjects:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // List of Subjects
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: programDetailss!.subjects.length,
                              itemBuilder: (context, index) {
                                final subject =
                                    programDetailss!.subjects[index].subject;
                                final recurrence =
                                    programDetailss!.subjects[index].recurrence;

                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subject.subjectName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Duration: ${subject.duration}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          'recurrence: ${programDetailss!.subjects[index].recurrence}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
