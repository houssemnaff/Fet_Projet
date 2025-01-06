import 'dart:io';
import 'package:fetprojet/api/profapi.dart'; // Import the profapi class
import 'package:fetprojet/components/drawer.dart';
import 'package:fetprojet/pages/admin/prof/profs.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileUploadPageprof extends StatefulWidget {
  const FileUploadPageprof({super.key});

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPageprof> {
  double uploadProgress = 0.0;
  String? fileName;
  bool isUploading = false;
  File? selectedFile; // Variable to store the selected file

  final profapi _profApi = profapi(); // Initialize profapi

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        selectedFile = File(result.files.single.path!); // Save the selected file
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred while selecting the file!',
      );
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'No file selected!',
      );
      return;
    }

    setState(() {
      isUploading = true;
      uploadProgress = 0.0;
    });

    // Simulate upload progress
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        uploadProgress = i / 100;
      });
    }

    // Call the API to upload the file
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString('sessionId') ?? '';
    if (sessionId.isNotEmpty) {
      String response = await _profApi.addprofTosessionWithFile(sessionId, selectedFile!);
      QuickAlert.show(
        context: context,
        type: response.contains('successfully') ? QuickAlertType.success : QuickAlertType.error,
        text: response.contains('successfully') ? 'File uploaded successfully!' : 'Failed to upload file.',
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Session ID not found!',
      );
    }

    setState(() {
      isUploading = false;
      fileName = null;
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        title: const Text('Teachers'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
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
                      'Upload File',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Select your file and click save to upload.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // File Selection Section
              GestureDetector(
                onTap: selectFile,
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
                        'Select your file to upload',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Display File Name after Selection
              if (fileName != null) ...[
                ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: Colors.yellow),
                  title: Text(fileName!),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        fileName = null;
                        selectedFile = null;
                      });
                    },
                  ),
                ),
              ],

              // Save Button
              ElevatedButton(
                onPressed: fileName != null ? uploadFile : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Upload Progress Section
              if (isUploading) ...[
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
              ],

              // Navigation Button to Teachers Page
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TeacherPage()),
                      );
                    },
                    child: const Text("All Teachers"),
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
