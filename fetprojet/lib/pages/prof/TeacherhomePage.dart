import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fetprojet/pages/prof/Teacherapi.dart';
import 'package:fetprojet/login.dart';
import 'package:fetprojet/pages/prof/EditprofileTeacher.dart';
import 'package:fetprojet/pages/prof/SelectDays_for_Work.dart';
import 'package:fetprojet/pages/prof/teacher.dart';

class Teacherhomepage extends StatefulWidget {
  const Teacherhomepage({super.key});

  @override
  State<Teacherhomepage> createState() => _TeacherhomepageState();
}

class _TeacherhomepageState extends State<Teacherhomepage> {
  SharedPreferences? prefs;
  Teacher? teacher;
  List<Map<String, dynamic>> timetable = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    prefs = await SharedPreferences.getInstance();
    await fetchUser();
    if (teacher != null) {
      await fetchTimetable();
    }
    debugPrint("Teacher: $teacher");
    debugPrint("Timetable: $timetable");
    setState(() {});
  }

  Future<void> fetchUser() async {
    try {
      Teacher fetchedTeacher = await Teacherapi().getTeacherById();
      setState(() {
        teacher = fetchedTeacher;
      });
    } catch (e) {
      debugPrint('Error fetching teacher: $e');
    }
  }

  Future<void> fetchTimetable() async {
    if (teacher == null) {
      debugPrint('Cannot fetch timetable: Teacher is null');
      return;
    }

    try {
      final response = await Teacherapi().getTimetable(teacher!.teacherName);
      setState(() {
        timetable = List<Map<String, dynamic>>.from(response['timetable']);
      });
    } catch (e) {
      debugPrint('Error fetching timetable: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teacher Home Page',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileTeacher()),
              );
            },
          ),
          if (prefs != null && prefs!.getString('role') == "Teacher")
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: buildTeacherTableemploi(context)),
            const SizedBox(height: 20),
            if (prefs != null && prefs!.getString('role') == "Teacher")
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectdaysForWork(),
                  ),
                ),
                child: const Text("Select Days for Work"),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTeacherTableemploi(BuildContext context) {
    if (timetable.isEmpty) {
      return const Center(child: Text('No timetable data available'));
    }

    final days = timetable.map((e) => e['day'] as String).toSet().toList();
    final timeSlots =
        timetable.map((e) => e['time_slot'] as String).toSet().toList();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: Colors.black),
          columnWidths: {
            0: const FixedColumnWidth(120), // Time slot column
            for (int i = 0; i < days.length; i++)
              i + 1: const FixedColumnWidth(240),
          },
          children: [
            // Header Row
            TableRow(
              decoration: BoxDecoration(color: Colors.blue[100]),
              children: [
                buildTableHeader('Time Slot'),
                for (var day in days) buildTableHeader(day),
              ],
            ),
            // Data Rows
            for (var timeSlot in timeSlots)
              TableRow(
                children: [
                  buildTableCell(timeSlot), // Time Slot Cell
                  for (var day in days)
                    buildTableSubjectWithDetails(
                      timetable.firstWhere(
                        (session) =>
                            session['day'] == day &&
                            session['time_slot'] == timeSlot,
                        orElse: () => {},
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTableCell(String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTableSubjectWithDetails(Map<String, dynamic> session) {
    final subject = session['subject'] ?? '';
    final room = session['room'] ?? '';
    final groupName = session['group_name'] ?? '';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            subject,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Room: $room",
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "Group: $groupName",
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
