import 'package:fetprojet/pages/prof/Subject.dart';
import 'package:fetprojet/pages/prof/Teacherapi.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'teacher.dart';

class EditProfileTeacher extends StatefulWidget {
  const EditProfileTeacher({super.key});

  @override
  State<EditProfileTeacher> createState() => _EditProfileTeacherState();
}

class _EditProfileTeacherState extends State<EditProfileTeacher> {
  List<Subject> allSubjects = [];
  List<String> selectedSubjects = [];
  Teacher? teacher;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teacherNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      await fetchTeacherData();
      await fetchAllSubjects();
      if (teacher != null) {
        _emailController.text = teacher!.email;
        _teacherNameController.text = teacher!.teacherName;
        selectedSubjects = teacher!.subjectsCanTeach.map((subject) => subject.id!).toList();
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to initialize data. Please try again.',
      );
      debugPrint('Error initializing data: $e');
    }
  }

  Future<void> fetchTeacherData() async {
    try {
      Teacher fetchedTeacher = await Teacherapi().getTeacherById();
      setState(() {
        teacher = fetchedTeacher;
      });
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to load teacher data. Please try again.',
      );
      debugPrint('Error fetching teacher data: $e');
    }
  }

  Future<void> fetchAllSubjects() async {
    try {
      List<Subject> fetchedSubjects = await Teacherapi().getallSubject();
      setState(() {
        allSubjects = fetchedSubjects;
      });
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to load subjects. Please try again.',
      );
      debugPrint('Error fetching subjects: $e');
    }
  }

  Future<void> updateTeacherProfile() async {
    if (_formKey.currentState!.validate() && teacher != null) {
      Teacher updatedTeacher = Teacher(
        id: teacher!.id,
        email: _emailController.text,
        cin: teacher!.cin,
        teacherName: _teacherNameController.text,
        valide: teacher!.valide,
        subjectsCanTeach: allSubjects
            .where((subject) => selectedSubjects.contains(subject.id))
            .toList(),
        timeSlots: teacher!.timeSlots,
      );

      try {
        await Teacherapi().updateTeacher(updatedTeacher);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Profile updated successfully.',
        );
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Error updating profile. Please try again.',
        );
        debugPrint('Error updating profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: teacher == null || allSubjects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _teacherNameController,
                        decoration: const InputDecoration(
                          labelText: 'Teacher Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex =
                              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Subjects You Can Teach:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ...allSubjects.map((subject) {
                        return CheckboxListTile(
                          title: Text(subject.subjectName),
                          value: selectedSubjects.contains(subject.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedSubjects.add(subject.id!);
                              } else {
                                selectedSubjects.remove(subject.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: updateTeacherProfile,
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
