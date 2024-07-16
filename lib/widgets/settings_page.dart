import 'package:flutter/material.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/utilities/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Options",
            style: TextStyle(fontSize: 20),
          ),
          ListTile(
            title: const Text("Export"),
            subtitle: const Text("Export all data"),
            leading: const Icon(Icons.ios_share),
            onTap: () {
              Utils.userExport();
            },
          ),
          ListTile(
            title: const Text("Import"),
            subtitle: const Text("Import from file"),
            leading: const Icon(Icons.download),
            onTap: () {
              Utils.userImport();
            },
          )
        ],
      ),
    );
  }
}
