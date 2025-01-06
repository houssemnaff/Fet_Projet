import 'dart:convert';

import 'package:fetprojet/api/sessionapi.dart';
import 'package:fetprojet/pages/admin/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionForm extends StatefulWidget {
  const SessionForm({super.key});
  

  @override
  _SessionFormState createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  final _formKey = GlobalKey<FormState>();

  String? year;
  String? universityName;
  TimeOfDay? timeBreakStart;
  TimeOfDay? timeBreakEnd;
  TimeOfDay? timeDayStart;
  TimeOfDay? timeDayEnd;
  List<String> activeDays = [];
  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  Future<void> _selectTime(
      BuildContext context, Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Year"),
                onChanged: (value) => year = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Year is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "University Name"),
                onChanged: (value) => universityName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'University name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                    "Break Start Time: ${timeBreakStart?.format(context) ?? 'Not set'}"),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context,
                    (picked) => setState(() => timeBreakStart = picked)),
              ),
              ListTile(
                title: Text(
                    "Break End Time: ${timeBreakEnd?.format(context) ?? 'Not set'}"),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, (picked) => setState(() => timeBreakEnd = picked)),
              ),
              ListTile(
                title: Text(
                    "Day Start Time: ${timeDayStart?.format(context) ?? 'Not set'}"),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, (picked) => setState(() => timeDayStart = picked)),
              ),
              ListTile(
                title: Text(
                    "Day End Time: ${timeDayEnd?.format(context) ?? 'Not set'}"),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, (picked) => setState(() => timeDayEnd = picked)),
              ),
              const SizedBox(height: 16),
              const Text("Active Days",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: daysOfWeek.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: activeDays.contains(day),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          activeDays.add(day);
                        } else {
                          activeDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendData();
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendData() async {
  // Préparer les données du formulaire avec valeurs par défaut
  final formData = {
    "year": year ?? "2025", // Valeur par défaut si null
    "universityName": universityName ?? "Default University",
    "timeBreakStart": timeBreakStart?.format(context) ?? "08:00 AM",
    "timeBreakEnd": timeBreakEnd?.format(context) ?? "09:00 AM",
    "timeDayStart": timeDayStart?.format(context) ?? "08:00 AM",
    "timeDayEnd": timeDayEnd?.format(context) ?? "05:00 PM",
    "activeDays": activeDays.isNotEmpty ? activeDays : ["Monday"], // Par défaut
  };

  print("Form Data: $formData");

  try {
    ApiService apiService = ApiService();
    Response? response = await apiService.addSession(formData);
    int stco=response!.statusCode;
    print("response $stco");
    if (response != null && response.statusCode == 201 ) {
      final responseData = json.decode(response.body);
      final String sessionId = responseData["sessionId"];
      print("Session created successfully with ID: $sessionId");

      // Enregistrer sessionId dans SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("sessionId", sessionId);

      String? userId = prefs.getString("userId");
      if (userId == null) {
        print("User ID not found in SharedPreferences.");
        return;
      }

      Response? updateResponse = await apiService.updateUserRolesAndSessions(
        userId,
        "Admin",
        [sessionId],
      );

      if (updateResponse != null && updateResponse.statusCode == 200) {
        print("User roles and sessions updated successfully!");

        // Naviguer vers le tableau de bord
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        print("Failed to update user roles and sessions.");
      }
    } else {
      print("Failed to create session.");
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}

}
