import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor:Colors.blue, // Utilisation de la couleur bleue comme dans les pages précédentes
        elevation: 0, // Pour un effet plat
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose your preferred language",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption(context, "English", const Locale('en')),
            _buildLanguageOption(context, "Français", const Locale('fr')),
            _buildLanguageOption(context, "Español", const Locale('es')),
            _buildLanguageOption(context, "عربي", const Locale('ar')),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language, Locale locale) {
    return Card(
      elevation: 4, // Ajout d'une légère ombre
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Coins arrondis
      ),
      child: ListTile(
        leading: const Icon(Icons.language, color: Color.fromARGB(255, 14, 7, 157)), // Icône de langue
        title: Text(
          language,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          _changeLanguage(context, locale);
        },
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Fonction pour changer la langue de l'application
  void _changeLanguage(BuildContext context, Locale locale) {
    // Fonction pour changer la langue ici
    // AppLocalizations.load(locale);
    // Recharger la page pour appliquer la langue
    Navigator.of(context).pop();
  }
}
