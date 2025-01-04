import 'package:flutter/material.dart';

class ScheduleManagementPage extends StatelessWidget {
  const ScheduleManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives pour l'exemple
    final List<Map<String, String>> schedules = [
      {"title": "Cours de Mathématiques", "time": "08:00 - 10:00", "day": "Lundi"},
      {"title": "Cours de Physique", "time": "10:15 - 12:15", "day": "Mardi"},
      {"title": "Cours de Chimie", "time": "14:00 - 16:00", "day": "Mercredi"},
      {"title": "Cours d'Informatique", "time": "09:00 - 11:00", "day": "Jeudi"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des emplois du temps'),
        backgroundColor:Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bouton pour ajouter un nouvel emploi
            ElevatedButton.icon(
              onPressed: () {
                // Logique pour ajouter un emploi
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              ),
              icon: const Icon(Icons.add,color: Colors.white,),
              label: const Text(
                "Ajouter un emploi",
                style: TextStyle(fontSize: 18.0,color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),

            // Liste des emplois
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.schedule, color: Colors.white),
                      ),
                      title: Text(
                        schedule['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        "${schedule['day']} | ${schedule['time']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Logique pour modifier un emploi
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Logique pour supprimer un emploi
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
