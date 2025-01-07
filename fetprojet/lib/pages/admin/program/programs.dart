import 'dart:convert';
import 'package:fetprojet/api/departmentapi.dart';
import 'package:fetprojet/api/groupsapi.dart';
import 'package:fetprojet/api/programapi.dart';
import 'package:fetprojet/api/subjectsapi.dart';
import 'package:fetprojet/dtoprogram.dart';
import 'package:fetprojet/pages/admin/program/afficherprograme.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({Key? key}) : super(key: key);

  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  final departmentApi = departmentapi();
  final programApi = ProgramApi(baseUrl: 'http://10.0.2.2:8081');
  String? selectedDepartmentId;
  List<Map<String, String>> departments = [];
  List<Map<String, String>> groups = [];
  final classapi _classApi = classapi();
  final departmentapi _depApi = departmentapi();
  String? selectedDepartment;
  String? selectedGroup;
  final subjectsApi = SubjectsApi();
  List<Subject> subjects = [];
  Map<String, TextEditingController> recurrenceControllers =
      {}; // To store controllers for recurrence input
  List<ProgramDto> appleProgram =
      []; // List to store Apple Program of type ProgramDto

  // New controller for Apple Program name
  final TextEditingController appleProgramNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

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
        fetchSubjects(); // Fetch subjects when groups are updated
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

  Future<void> fetchSubjects() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId =
          prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";
      final List<Subject> fetchedSubjects =
          await subjectsApi.getSubjects(sessionId);

      setState(() {
        subjects = fetchedSubjects; // Update the subjects list

        // Initialize the TextEditingController for each subject
        for (var subject in subjects) {
          recurrenceControllers[subject.name] = TextEditingController();
        }
      });
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred while fetching subjects: $e',
      );
    }
  }

  // Function to add subject and recurrence to Apple Program list
  void addToAppleProgram(String subjectName, String duration) {
    final recurrence = recurrenceControllers[subjectName]?.text ?? '';
    if (recurrence.isNotEmpty) {
      setState(() {
        // Create a ProgramDto with the Apple Program name and add subjects
        final program = ProgramDto(
          programName: appleProgramNameController.text,
          subjects: [
            ProgramSubjectDto(
              subject: SubjectDetailsDto(
                subjectName: subjectName,
                duration: duration,
              ),
              recurrence: int.tryParse(recurrence) ??
                  0, // Ensure recurrence is an integer
            ),
          ],
        );

        // Add ProgramDto to the appleProgram list
        appleProgram.add(program);
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text:
            '$subjectName added to Apple Program with recurrence $recurrence.',
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Please enter recurrence for $subjectName.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Program Management'),
        actions: [IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              // Navigate to AfficheProgram when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AfficheProgram()),
              );
            },
          ),],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Apple Program Name Input
            TextField(
              controller: appleProgramNameController,
              decoration: InputDecoration(
                labelText: 'Enter Apple Program Name', // Label text
                labelStyle: TextStyle(
                  color: Colors.blueAccent, // Label text color
                  fontWeight: FontWeight.w600, // Make the label text bold
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2), // Border color and width
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue, width: 2), // Focused border color
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey, width: 2), // Default border color
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20), // Padding inside the TextField
              ),
            ),

            const SizedBox(height: 20),

            // Department Dropdown
            DropdownButton<String>(
              value: selectedDepartment,
              hint: const Text('Select Department'),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                  selectedGroup = null; // Reset group when department changes
                });
                fetchGroups(value!); // Fetch groups for selected department
              },
              style: TextStyle(
                color: Colors.black, // Text color for the selected item
                fontWeight: FontWeight
                    .w500, // Medium font weight for better readability
              ),
              iconEnabledColor:
                  Colors.blueAccent, // Icon color when dropdown is expanded
              underline: Container(), // Removes the default underline
              dropdownColor:
                  Colors.white, // Background color of the dropdown menu
              isExpanded:
                  true, // Makes the dropdown button fill the available width
              items: departments.map((department) {
                return DropdownMenuItem(
                  value: department['departmentId'],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0), // Padding inside each dropdown item
                    child: Text(
                      department['departmentName']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight
                            .w400, // Light font weight for dropdown items
                      ),
                    ),
                  ),
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
                style: TextStyle(
                  color: Colors.black, // Text color for the selected item
                  fontWeight: FontWeight
                      .w500, // Medium font weight for better readability
                ),
                iconEnabledColor:
                    Colors.blueAccent, // Icon color when dropdown is expanded
                underline: Container(), // Removing default underline
                dropdownColor:
                    Colors.white, // Background color of the dropdown menu
                isExpanded:
                    true, // Makes the dropdown button fill the available width
                items: groups.map((group) {
                  return DropdownMenuItem(
                    value: group['groupId'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal:
                              16.0), // Padding inside each dropdown item
                      child: Text(
                        group['groupName']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight
                              .w400, // Light font weight for dropdown items
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            // Display Subjects List with Recurrence Input
            if (subjects.isNotEmpty) const SizedBox(height: 20),
            if (subjects.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return Card(
                      // Wrapping the ListTile in a Card for a more defined look
                      margin: EdgeInsets.symmetric(
                          vertical: 8.0), // Spacing between items
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Rounded corners for the card
                      ),
                      elevation: 4, // Subtle shadow for depth
                      child: ListTile(
                        contentPadding: EdgeInsets.all(
                            16.0), // Add padding inside the ListTile
                        title: Text(
                          subject.name,
                          style: TextStyle(
                            fontSize: 18, // Slightly larger font for the title
                            fontWeight: FontWeight
                                .bold, // Bold font for the subject name
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height:
                                    8), // Add space between title and duration text
                            Text(
                              'Duration: ${subject.duration}',
                              style: TextStyle(
                                fontSize:
                                    14, // Slightly smaller font for the duration
                                color: Colors
                                    .grey[700], // Grey color for the subtitle
                              ),
                            ),
                            SizedBox(
                                height:
                                    12), // Add space between duration and input field
                            TextField(
                              controller: recurrenceControllers[subject.name],
                              decoration: InputDecoration(
                                labelText:
                                    'Enter recurrence for ${subject.name}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Rounded corners for input field
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical:
                                        8.0), // Padding inside the TextField
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize:
                                      16), // Larger font for the input text
                            ),
                            SizedBox(
                                height:
                                    12), // Add space between input field and button
                            ElevatedButton(
                              onPressed: () => addToAppleProgram(
                                  subject.name, subject.duration),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blueAccent, // Set the button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners for the button
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 20), // Button padding
                              ),
                              child: Text(
                                'Add to Apple Program',
                                style: TextStyle(
                                  fontSize: 16, // Font size for the button text
                                  fontWeight: FontWeight
                                      .bold, // Bold text for the button
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Apple Program List Display
            if (appleProgram.isNotEmpty) const SizedBox(height: 20),
            if (appleProgram.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: appleProgram.length,
                  itemBuilder: (context, index) {
                    final appleProgramItem = appleProgram[index];
                    return ListTile(
                      title: Text(appleProgramItem.programName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: appleProgramItem.subjects.map((subjectDto) {
                          return Text(
                            'Subject: ${subjectDto.subject.subjectName}, Duration: ${subjectDto.subject.duration}, Recurrence: ${subjectDto.recurrence}',
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                String? sessionId =
                    prefs.getString("sessionId") ?? "6767ed5018e2bd7ea42682c7";

                if (selectedDepartment != null &&
                    selectedGroup != null &&
                    appleProgram.isNotEmpty) {
                  final programDto = ProgramDto(
                    programName: appleProgramNameController.text,
                    subjects: appleProgram
                        .expand((program) => program.subjects)
                        .toList(),
                  );

                  bool isProgramAdded = await programApi.addProgramToGroup(
                    sessionId: sessionId,
                    departmentId: selectedDepartment!,
                    groupId: selectedGroup!,
                    programDto: programDto,
                  );

                  if (isProgramAdded) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Program added successfully!',
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Failed to add program. Please try again.',
                    );
                  }
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text:
                        'Please ensure all fields are selected and the program is not empty.',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
                padding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 32), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 5, // Shadow effect
              ),
              child: Text(
                'Save Program',
                style: TextStyle(
                  fontSize: 16, // Font size
                  fontWeight: FontWeight.bold, // Text weight
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
