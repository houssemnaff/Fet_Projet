import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DepartmentPage extends StatefulWidget {
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
      text: 'ins terminer',
    );
    }
  }

  void _editDepartment(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _editController = TextEditingController(
          text: _departments[index],
        );

        return AlertDialog(
          title: Text("Edit Department"),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(labelText: "Department Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _departments[index] = _editController.text.trim();
                });
                Navigator.of(context).pop();
               
              },
              child: Text("Save"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Departments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Department",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _departmentController,
                    decoration: InputDecoration(
                      labelText: "Department Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addDepartment,
                  child: Text("Add"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "List of Departments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _departments.isNotEmpty
                  ? ListView.builder(
                      itemCount: _departments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(_departments[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editDepartment(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteDepartment(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text("No departments added yet."),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
