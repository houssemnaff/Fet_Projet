import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:quickalert/quickalert.dart'; // Import QuickAlert package

class ScheduleManagementPage extends StatefulWidget {
  const ScheduleManagementPage({super.key});

  @override
  _ScheduleManagementPageState createState() => _ScheduleManagementPageState();
}

class _ScheduleManagementPageState extends State<ScheduleManagementPage> {
  // Function to fetch sessionId from SharedPreferences
  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId'); // Get sessionId from SharedPreferences
  }

  // Function to call the API and fetch the timetable
  Future<void> generateTimetable() async {
    String? sessionId = await getSessionId(); // Fetch sessionId from SharedPreferences

    if (sessionId == null) {
      // Handle case when sessionId is not available
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Session ID is not available.',
      );
      return;
    }

    // Define the URL for the API request
    final url = Uri.parse('http://localhost:5000/generate-timetable');

    // Set up the headers and body for the request
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"sessionId": sessionId});

    try {
      // Send the POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check if the response status is successful
      if (response.statusCode == 200) {
        // Successfully received data
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Timetable generated successfully.',
        );
      } else {
        // Handle non-successful response
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to generate timetable.',
        );
      }
    } catch (e) {
      // Handle any errors that occur during the request
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error generating timetable: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des emplois du temps'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bouton pour ajouter un nouvel emploi
            ElevatedButton.icon(
              onPressed: () {
                // Call the function to generate timetable when button is pressed
                generateTimetable();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                "Ajouter un emploi",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
