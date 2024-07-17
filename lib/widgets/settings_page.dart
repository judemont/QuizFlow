import 'package:flutter/material.dart';
import 'package:quizflow/utilities/utils.dart';
import 'package:url_launcher/url_launcher.dart';

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
          ),
          const SizedBox(),
          const Text(
            "About",
            style: TextStyle(fontSize: 20),
          ),
          ListTile(
            title: const Text("Source Code"),
            leading: const Icon(Icons.code),
            subtitle: const Text("github.com/judemont/QuizFlow"),
            onTap: () =>
                launchUrl(Uri.parse("https://github.com/judemont/QuizFlow")),
          ),
          ListTile(
            title: const Text("Rate QuizFlow on Google Play"),
            leading: const Icon(Icons.star),
            subtitle: const Text(
                "play.google.com/store/apps/details?id=jdm.apps.quizflow"),
            onTap: () => launchUrl(Uri.parse(
                "https://play.google.com/store/apps/details?id=jdm.apps.quizflow")),
          ),
        ],
      ),
    );
  }
}
