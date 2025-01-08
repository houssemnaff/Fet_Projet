import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Map<String, dynamic> timetableData = {};
  List<dynamic> timetable = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadTimetableData();
  }

  Future<void> loadTimetableData() async {
    final String groupName = 'aaaa';
    final String sessionId = '6767ed5018e2bd7ea42682c7';
    final Uri apiUri = Uri.parse(
      'http://localhost:5000/get-timetable-by-group-and-session?groupName=$groupName&sessionId=$sessionId',
    );

    try {
      final response = await http.get(apiUri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          timetableData = data["timetables"] as Map<String, dynamic>;
          timetable = timetableData[groupName] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur ${response.statusCode}: Impossible de charger les données.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion : $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emploi du Temps"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : timetable.isEmpty
                  ? const Center(child: Text("Aucune donnée disponible."))
                  : Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: DataTable(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            columns: const [
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Jour',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Matière',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Enseignant',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Salle',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Horaire',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              timetable.length,
                              (index) {
                                final entry = timetable[index];
                                final isEven = index % 2 == 0;
                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      return isEven ? Colors.blue.shade50 : null;
                                    },
                                  ),
                                  cells: [
                                    DataCell(LeftAlignedText(entry["day"] ?? "Inconnu")),
                                    DataCell(LeftAlignedText(entry["subject"] ?? "Inconnu")),
                                    DataCell(LeftAlignedText(entry["teacher"] ?? "Inconnu")),
                                    DataCell(LeftAlignedText(entry["room"] ?? "Inconnu")),
                                    DataCell(LeftAlignedText(entry["time_slot"] ?? "Inconnu")),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
    );
  }
}

class LeftAlignedText extends StatelessWidget {
  final String text;

  const LeftAlignedText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }
}
