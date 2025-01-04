import 'dart:convert';

import 'package:fetprojet/api/sessionapi.dart';
import 'package:fetprojet/pages/admin/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';

class SessionForm extends StatefulWidget {
  const SessionForm({super.key, required this.user});
  final User user;

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
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "University Name"),
                onChanged: (value) => universityName = value,
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
    // Préparer les données du formulaire
    final formData = {
      "year": year,
      "universityName": universityName,
      "timeBreakStart": timeBreakStart?.format(context),
      "timeBreakEnd": timeBreakEnd?.format(context),
      "timeDayStart": timeDayStart?.format(context),
      "timeDayEnd": timeDayEnd?.format(context),
      "activeDays": activeDays,
    };

    // Utiliser ApiService pour envoyer les données
    ApiService apiService = ApiService();
    Response? response = await apiService.addSession(formData);

    if (response != null && response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final String sessionId = responseData["id"]; // Récupérer l'ID de la session
      print("Session created successfully with ID: $sessionId");

      // Associer la session à l'utilisateur
      Response? updateResponse = await apiService.updateUserRolesAndSessions(
        widget.user.uid,
        "SuperAdmin", // Vous pouvez personnaliser le rôle ici
        [sessionId], // Ajouter l'ID de la session créée
      );

      if (updateResponse != null && updateResponse.statusCode == 200) {
        print("User roles and sessions updated successfully!");
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
  }
}
