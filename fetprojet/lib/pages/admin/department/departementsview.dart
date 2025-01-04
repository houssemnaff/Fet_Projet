import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  final TextEditingController _departmentController = TextEditingController();
  final List<String> _departments = [];

  void _addDepartment() {
    String departmentName = _departmentController.text.trim();
    if (departmentName.isNotEmpty) {
      setState(() {
        _departments.add(departmentName);
      });
      _departmentController.clear();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Department added successfully',
      );
    }
  }

  void _editDepartment(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController editController = TextEditingController(
          text: _departments[index],
        );

        return AlertDialog(
          title: const Text("Edit Department"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: "Department Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _departments[index] = editController.text.trim();
                });
                Navigator.of(context).pop();
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Department updated successfully',
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteDepartment(int index) {
    setState(() {
      _departments.removeAt(index);
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: 'Department deleted successfully',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                    'Enregistrement des département',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Sélectionnez un département et enregistrez un class',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                     // textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Department Input Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _departmentController,
                      decoration: const InputDecoration(
                        labelText: "Department Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addDepartment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Department List Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'List of Departments:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // List of added departments
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _departments.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _departments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(_departments[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editDepartment(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteDepartment(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No departments added yet."),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
