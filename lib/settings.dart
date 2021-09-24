import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final SharedPreferences preferences;
  const SettingsPage(this.preferences, {Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(
        text: widget.preferences.getString("search") ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Recherche"),
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {
                    showDialog(
                        context: (context),
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Aide"),
                            content: Column(
                              children: const [
                                Text(
                                    "Entrez le terme de recherche que vous entreriez dans la barre de recherche de telle sorte à ce que votre formation apparaisse en premier dans la liste"),
                                Divider(),
                                Text(
                                    "Exemple : 'm2 tech' suffit pour le Master 2 Technologies de l'Internet"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Fermer"))
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: MediaQuery.of(context).size.width / 2),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  widget.preferences.setString("search", value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
