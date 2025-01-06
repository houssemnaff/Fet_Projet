import 'dart:convert';
import 'dart:io';
import 'package:fetprojet/api/departmentapi.dart';
import 'package:fetprojet/api/etudiantapi.dart';
import 'package:fetprojet/api/groupsapi.dart';
import 'package:fetprojet/components/drawer.dart';
import 'package:fetprojet/pages/admin/etudiant/etudiants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  double uploadProgress = 0.0;
  String? fileName;
  bool isUploading = false;
  bool isFileSelected = false;  // Flag to track if a file has been selected

  // Department and group selection
  String? selectedDepartment;
  String? selectedGroup;
  List<Map<String, String>> departments = [];
  List<Map<String, String>> groups = [];
  
  final departmentapi _depApi = departmentapi();
  final classapi _classApi = classapi();

  // Select file from the user's device
  Future<void> selectFile() async {
  if (selectedDepartment == null || selectedGroup == null) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'Please select a department and group before selecting a file.',
    );
    return;
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    setState(() {
      fileName = result.files.single.path; // Use the full path here
      uploadProgress = 0.0;
      isUploading = true;
      isFileSelected = true; // Mark file as selected
    });
    uploadFile();
  } else {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'An error occurred while selecting the file!',
    );
  }
}


  // Simulate file upload
  Future<void> uploadFile() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        uploadProgress = i / 100;
      });
    }
    setState(() {
      isUploading = false;
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Insertion completed successfully!',
    );
  }

  // Save student with file
Future<void> saveStudentWithFile() async {
  if (selectedDepartment != null && selectedGroup != null && fileName != null) {
    setState(() {
      isUploading = true;
    });

    // Create instance of EtudiantApi to call API
    EtudiantApi etudiantApi = EtudiantApi();

    try {
      // Ensure file exists
      File studentFile = File(fileName!);
      if (!studentFile.existsSync()) {
        throw Exception('File not found at the specified path.');
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";

      // Call API to upload the file
      String response = await etudiantApi.addStudentToGroupWithFile(
        sessionId,
        selectedDepartment!,
        selectedGroup!,
        studentFile,
      );

      // Handle the response from the API
      if (response.contains("success")) {
         QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Insertion completed successfully!',
        );
        setState(() {
          isUploading = false;
        });

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Insertion completed successfully!',
        );
      } else {
        setState(() {
          isUploading = false;
        });

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed: $response', // Display the response from the server
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred during file upload: $e',
      );
    }
  } else {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'Please select a department, group, and file before uploading.',
    );
  }
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

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        title: const Text('Students'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Department Selection Section
              DropdownButton<String>(
                value: selectedDepartment,
                hint: const Text('Select Department'),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                    selectedGroup = null; // Reset group when department changes
                    isFileSelected = false;  // Reset file selection
                  });
                  fetchGroups(value!); // Fetch groups for selected department
                },
                items: departments.map((department) {
                  return DropdownMenuItem(
                    value: department['departmentId'],
                    child: Text(department['departmentName']!),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Group Selection Section
              if (selectedDepartment != null)
                DropdownButton<String>(
                  value: selectedGroup,
                  hint: const Text('Select Group'),
                  onChanged: (value) {
                    setState(() {
                      selectedGroup = value;
                    });
                  },
                  items: groups.map((group) {
                    return DropdownMenuItem(
                      value: group['groupId'],
                      child: Text(group['groupName']!),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 20),

              // File Selection Section (disabled after file is selected)
              GestureDetector(
                onTap: isFileSelected ? null : selectFile,  // Disable tap after file selection
                child: AbsorbPointer(
                  absorbing: isFileSelected,  // Disable interactions after file selection
                  child: Container(
                    padding: const EdgeInsets.all(70),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.folder, size: 40, color: Colors.blue),
                        const SizedBox(height: 10),
                        const Text(
                          'Drag your file(s) to start uploading\nOR',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: isFileSelected ? null : selectFile,  // Disable after file is selected
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Browse Files',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Upload Progress Section
              if (isUploading) ...[
                const SizedBox(height: 20),
                LinearPercentIndicator(
                  lineHeight: 8.0,
                  percent: uploadProgress,
                  backgroundColor: Colors.grey[300]!,
                  progressColor: Colors.blue,
                ),
                const SizedBox(height: 10),
                Text(
                  'Uploading... ${(uploadProgress * 100).toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.pause_circle_outline),
                      onPressed: () {
                        // Add pause functionality here if needed
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          isUploading = false;
                          uploadProgress = 0.0;
                        });
                      },
                    ),
                  ],
                ),
              ],

              // Display File Name after Selection
              if (!isUploading && fileName != null) ...[
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: Colors.yellow),
                  title: Text(fileName!),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        fileName = null;
                        isFileSelected = false;  // Reset file selection
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: saveStudentWithFile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Save'),
                ),
              ],

              // Navigation Button to Students Page
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EtudiantPage()),
                      );
                    },
                    child: const Text("All Students"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
