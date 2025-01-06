import 'dart:convert';
import 'package:fetprojet/api/departmentapi.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  final TextEditingController _departmentController = TextEditingController();
  final List<Map<String, String>> _departments = []; // Liste des départements avec ID et nom
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
  final departmentapi _depApi = departmentapi(); // Instance de l'API
@override
void initState() {
  super.initState();
  getAllDepartmentsBySession(); // Appeler la fonction dès que la page est construite
}

  // Récupérer tous les départements par session
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

  // Ajouter un département
  Future<void> _addDepartment() async {
    if (_formKey.currentState!.validate()) {
      String departmentName = _departmentController.text.trim();

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

        final response = await _depApi.addDepartmentToSession(sessionId, departmentName);

        if (response.statusCode == 200) {
         getAllDepartmentsBySession();
          _departmentController.clear();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Department added successfully!',
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Failed to add department. Please try again.',
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
  }

  // Modifier un département
 Future<void> _editDepartment(int index) async {
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

  String? departmentId = _departments[index]['departmentId'];
  if (departmentId == null || departmentId.isEmpty) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'Invalid department ID. Please try again.',
    );
    return;
  }

  // Préparer le champ de modification
  final TextEditingController editController = TextEditingController(
    text: _departments[index]['departmentName'],
  );

  // Afficher une boîte de dialogue pour modifier le nom
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Department"),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(labelText: "Department Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              String newName = editController.text.trim();

              if (newName.isNotEmpty) {
                try {
                  // Envoyer la mise à jour au serveur
                  final response = await _depApi.updateDepartment(sessionId, departmentId, newName);

                  if (response.statusCode == 200) {
                    // Mettre à jour la liste localement
                    setState(() {
                      _departments[index]['departmentName'] = newName;
                    });

                    Navigator.of(context).pop(); // Fermer la boîte de dialogue

                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Department updated successfully.',
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Failed to update department. Please try again.',
                    );
                  }
                } catch (e) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: 'An error occurred: $e',
                  );
                }
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: 'Name cannot be empty.',
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
// Supprimer un département
Future<void> _deleteDepartment(String? depId) async {
  if (depId == null || depId.isEmpty) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'Invalid department ID. Please try again.',
    );
    return;
  }

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

    final response = await _depApi.deleteDepartment(sessionId, depId);

    if (response.statusCode == 200) {
      setState(() {
        _departments.removeWhere((dept) => dept['departmentId'] == depId);
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Department deleted successfully.',
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to delete department. Please try again.',
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: const Column(
                children: [
                  Text(
                    'Enregistrement des départements',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Formulaire d'ajout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _departmentController,
                        decoration: const InputDecoration(
                          labelText: "Department Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a department name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addDepartment,
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Liste des départements
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _departments.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _departments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_departments[index]['departmentName'] ?? ''),
                            
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editDepartment(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDepartment(_departments[index]['departmentId']),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("No departments added yet.")),
            ),
          ],
        ),
      ),
    );
  }
}
