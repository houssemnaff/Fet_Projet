import 'package:fetprojet/api/subjectsapi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

class SubjectsPage extends StatefulWidget {
  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<Subject> subjects = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString("sessionId") ??
          "677b0b7fa6a4a2051bf80cd2"; // Default session ID
      final api = SubjectsApi();
      final subjectsList = await api.getSubjects(sessionId);
      setState(() {
        subjects = subjectsList;
      });
      print("subject $subjects");
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }

  Future<void> _addSubject() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("sessionId") ??
        "6767ed5018e2bd7ea42682c7"; // Default session ID

    if (_nameController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _typeController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Warning',
        text: 'Please fill in all fields!',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
      return;
    }

    final newSubject = Subject(
      subjectId: '', // Provide method for subject ID generation if needed
      name: _nameController.text,
      duration: _durationController.text,
      type: _typeController.text,
    );

    final api = SubjectsApi();
    String result = await api.addSubject(sessionId, newSubject);

    if (result == 'Subject added successfully') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Subject added successfully!',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
      _loadSubjects(); // Refresh the list
    } else if (result ==
        'Subject with the same name already exists in the session') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Subject already exists with this name!',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to add subject. Please try again.',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
    }
  }

  Future<void> _deleteSubject(String subjectId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("sessionId") ??
        "6767ed5018e2bd7ea42682c7"; // Default session ID
    final api = SubjectsApi();
    String result = await api.deleteSubject(sessionId, subjectId);

    if (result == 'Subject deleted successfully') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Subject deleted successfully!',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
      _loadSubjects(); // Refresh the list after deletion
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to delete subject.',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
    }
  }

  Future<void> _updateSubject(String subjectId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("sessionId") ??
        "6767ed5018e2bd7ea42682c7"; // Default session ID

    if (_nameController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _typeController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Warning',
        text: 'Please fill in all fields!',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
      return;
    }

    final updatedSubject = Subject(
      subjectId: subjectId,
      name: _nameController.text,
      duration: _durationController.text,
      type: _typeController.text,
    );

    final api = SubjectsApi();
    String result =
        await api.updateSubject(sessionId, subjectId, updatedSubject);

    if (result == 'Subject updated successfully') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Subject updated successfully!',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
      _loadSubjects(); // Refresh the list
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to update subject.',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close the dialog
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: subjects.isEmpty
          ? Center(
              child: Text(
                'No subjects available. Please add a subject.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      subject.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Duration: ${subject.duration}, Type: ${subject.type}',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Pré-remplir les champs avec les valeurs existantes
                            _nameController.text = subject.name;
                            _durationController.text = subject.duration;
                            _typeController.text = subject.type;

                            // Afficher le formulaire dans une boîte de dialogue
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Edit Subject'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                            labelText: 'Subject Name',
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: _durationController,
                                          decoration: InputDecoration(
                                            labelText: 'Duration',
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: _typeController,
                                          decoration: InputDecoration(
                                            labelText: 'Type',
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Fermer la boîte de dialogue
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Appeler la fonction de mise à jour
                                        _updateSubject(subject.subjectId);
                                        Navigator.pop(
                                            context); // Fermer la boîte de dialogue après la mise à jour
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteSubject(subject.subjectId);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the form in a dialog to add a new subject
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add New Subject'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Subject Name',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _durationController,
                        decoration: InputDecoration(
                          labelText: 'Duration',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _typeController,
                        decoration: InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addSubject(); // Call the addSubject function
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
