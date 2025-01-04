import 'package:flutter/material.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives pour l'exemple
    final double currentBalance = 1250.75;
    final List<Map<String, String>> transactions = [
      {"title": "Paiement reçu", "amount": "+150.00", "date": "02/01/2025"},
      {"title": "Achat", "amount": "-200.00", "date": "01/01/2025"},
      {"title": "Paiement reçu", "amount": "+300.00", "date": "31/12/2024"},
      {"title": "Retrait", "amount": "-100.00", "date": "30/12/2024"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Finances'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solde actuel
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Solde actuel",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "\$${currentBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Historique des transactions
            const Text(
              "Historique des transactions",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8.0),

            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final isCredit = transaction['amount']!.startsWith('+');

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        backgroundColor: isCredit ? Colors.green : Colors.red,
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        transaction['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        transaction['date']!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Text(
                        transaction['amount']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCredit ? Colors.green : Colors.red,
                          fontSize: 16.0,
                        ),
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
