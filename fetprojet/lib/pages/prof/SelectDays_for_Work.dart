import 'package:fetprojet/login.dart';
import 'package:fetprojet/pages/prof/EditprofileTeacher.dart';
import 'package:flutter/material.dart';

class SelectdaysForWork extends StatefulWidget {
  const SelectdaysForWork({super.key});

  @override
  State<SelectdaysForWork> createState() => _SelectdaysForWorkState();
}

class _SelectdaysForWorkState extends State<SelectdaysForWork> {
  late List<Seance> seances;

  @override
  void initState() {
    super.initState();
    seances = generateSeances();
  }

  List<Seance> generateSeances() {
    List<Seance> seances = [];
    List<String> horaires = [
      '8:30',
      '10:05',
      '11:40',
      '13:15',
      '14:50',
      '16:25'
    ];
    List<String> finHoraires = [
      '10:00',
      '11:35',
      '13:10',
      '14:45',
      '16:20',
      '17:50'
    ];
    List<String> noms = ['s1', 's2', 's3', 's4', 's5', 's6'];

    for (int i = 0; i < noms.length; i++) {
      seances.add(Seance(
        debut: horaires[i],
        fin: finHoraires[i],
        nom: noms[i],
        etaps: List.generate(6, (index) => false),
      ));
    }

    return seances;
  }

  Widget buildTeacherTableemploi(BuildContext context) {
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: Colors.black),
          columnWidths: {
            0: FixedColumnWidth(100),
            for (int i = 0; i < days.length; i++) i + 1: FixedColumnWidth(150),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.blue[100]),
              children: [
                buildTableHeader('Séance'),
                for (var day in days) buildTableHeader(day),
              ],
            ),
            for (var seance in seances)
              TableRow(
                children: [
                  buildSeanceRow(seance),
                  for (int i = 0; i < seance.etaps.length; i++)
                    buildCheckboxCell(seance, i),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSeanceRow(Seance seance) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            '${seance.nom} ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              Text(
                '${seance.debut}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${seance.fin}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
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

  Widget buildCheckboxCell(Seance seance, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Checkbox(
        value: seance.etaps[index],
        onChanged: (bool? value) {
          setState(() {
            seance.etaps[index] = value!;
          });
        },
      ),
    );
  }

  void showAllSeancesResults() {
    List<String> allSeancesResults = [];
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    for (var seance in seances) {
      for (int i = 0; i < seance.etaps.length; i++) {
        allSeancesResults.add(
          '${seance.nom} ${seance.debut} ${seance.fin} ${days[i]} ${seance.etaps[i]}',
        );
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Seances Results'),
          content: SingleChildScrollView(
            child: Column(
              children: allSeancesResults.isEmpty
                  ? [const Text('No seances available')]
                  : allSeancesResults.map((e) => Text(e)).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Days for Work',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: showAllSeancesResults,
                  child: const Text('Get Results'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Seance {
  final String debut;
  final String fin;
  final String nom;
  List<bool> etaps;
  Seance({
    required this.debut,
    required this.fin,
    required this.nom,
    required this.etaps,
  });
}
