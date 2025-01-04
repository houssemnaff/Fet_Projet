import 'package:fetprojet/components/drawer.dart';
import 'package:fetprojet/pages/admin/prof/profs.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class FileUploadPageprof extends StatefulWidget {
  const FileUploadPageprof({super.key});

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPageprof> {
  double uploadProgress = 0.0;
  String? fileName;
  bool isUploading = false;

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        uploadProgress = 0.0;
        isUploading = true;
      });
      uploadFile();
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred!',
      );
    }
  }

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
      text: 'Insertion Completed Successfully!',
    );
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
                    // App Header
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
                      'Drag your files or browse to start uploading.',
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
                        'Drag your file(s) to start uploading\nOR',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: selectFile,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Browse Files',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
                        // Pause functionality (if needed)
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
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Code to save the file if needed
                  },
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
                        MaterialPageRoute(builder: (context) => TeacherPage()),
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
