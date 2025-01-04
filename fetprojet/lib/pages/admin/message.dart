import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste de messages fictifs pour l'exemple
    final List<Map<String, String>> messages = [
      {"title": "Message 1", "content": "Ceci est le contenu du message 1."},
      {"title": "Message 2", "content": "Ceci est le contenu du message 2."},
      {"title": "Message 3", "content": "Ceci est le contenu du message 3."},
      {"title": "Message 4", "content": "Ceci est le contenu du message 4."},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
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
                  child: Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  message['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  message['content']!,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: Colors.grey,
                ),
                onTap: () {
                  // Action lors du clic sur un message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(message['title']!),
                      content: Text(message['content']!),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Fermer"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
