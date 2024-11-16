import 'package:fetprojet/components/drawer.dart';
import 'package:fetprojet/pages/admin/etudiants.dart';
import 'package:fetprojet/pages/admin/profs.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  double uploadProgress = 0.0;
  String? fileName;
  bool isUploading = false;

  Future<void> selectFile() async {
    //final result = await FilePicker.platform.pickFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        uploadProgress = 0.0;
        isUploading = true;
      });
      uploadFile();
    }else{
       QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'same erreur hap!',
    );
    }
  }

  Future<void> uploadFile() async {
    // Simulation de l'upload
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 50));
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
      text: 'insertion Completed Successfully!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      appBar: AppBar(
        title: Text('studiants'),
       
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Upload file',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: selectFile,
              child: Container(
                padding: EdgeInsets.all(70),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.blueAccent), // Suppression de dashPattern
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.folder, size: 40, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text('Drag your file(s) to start uploading\nOR',
                        textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: selectFile,
                      child: Text('Browse files'),
                    ),
                  ],
                ),
              ),
            ),
            if (isUploading) ...[
              SizedBox(height: 20),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: uploadProgress,
                backgroundColor: Colors.grey[300],
                progressColor: Colors.blue,
              ),
              SizedBox(height: 10),
              Text(
                'Uploading... ${(uploadProgress * 100).toStringAsFixed(0)}%',
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.pause_circle_outline),
                    onPressed: () {
                      // Ajoutez ici la fonctionnalité pour mettre en pause
                    },
                  ),
                  IconButton(
                    icon: Icon(
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
            if (!isUploading && fileName != null) ...[
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.yellow),
                title: Text(fileName!),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      fileName = null;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Code pour sauvegarder le fichier
                },
                child: Text('Save'),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue), // Couleur bleue
                    foregroundColor:
                        MaterialStateProperty.all(Colors.white), // Texte blanc
                  ),
                  onPressed: () {
                    // Redirige vers la page "Teachers"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EtudiantPage()),
                    );
                  },
                  child: Text("All Etudiants"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
