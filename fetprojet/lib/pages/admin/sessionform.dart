import 'dart:convert';

import 'package:fetprojet/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SessionForm extends StatefulWidget {
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
        title: Text("Session Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Year"),
                onChanged: (value) => year = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "University Name"),
                onChanged: (value) => universityName = value,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                    "Break Start Time: ${timeBreakStart?.format(context) ?? 'Not set'}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context,
                    (picked) => setState(() => timeBreakStart = picked)),
              ),
              ListTile(
                title: Text(
                    "Break End Time: ${timeBreakEnd?.format(context) ?? 'Not set'}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, (picked) => setState(() => timeBreakEnd = picked)),
              ),
              ListTile(
                title: Text(
                    "Day Start Time: ${timeDayStart?.format(context) ?? 'Not set'}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, (picked) => setState(() => timeDayStart = picked)),
              ),
              ListTile(
                title: Text(
                    "Day End Time: ${timeDayEnd?.format(context) ?? 'Not set'}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, (picked) => setState(() => timeDayEnd = picked)),
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: ()  {
                  if (_formKey.currentState!.validate()) {
                    sendData();
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

 void sendData() async{
  // Prepare data in JSON format
                    final formData = {
                      "year": year,
                      "universityName": universityName,
                      "timeBreakStart": timeBreakStart?.format(context),
                      "timeBreakEnd": timeBreakEnd?.format(context),
                      "timeDayStart": timeDayStart?.format(context),
                      "timeDayEnd": timeDayEnd?.format(context),
                      "activeDays": activeDays,
                    };
                    const url ="http://10.0.2.2:8081/admin/sessions";
                    // Make the HTTP POST request
                    final response = await http.post(
                      Uri.parse(url), // Replace with your API URL
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: jsonEncode(formData),
                    );

                    // Handle response
                    if (response.statusCode == 200) {
                      print("Data submitted successfully!");
                      Navigator.pushReplacement((context), MaterialPageRoute(builder: (context) => Dashboard(),));
                     
                    } else {
                      print(
                          "Failed to submit data. Error 111111111111111111111111111111: ${response.statusCode}");
                      // Optionally, display an error message
                    }
 }
}