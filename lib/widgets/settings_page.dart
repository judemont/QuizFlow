import 'package:flutter/material.dart';
import 'package:quizflow/main.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_archive/flutter_archive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String theme = "";

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      theme = prefs.getString('theme') ?? "system";
    });

    super.initState();
  }

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
            title: const Text("Theme"),
            leading: const Icon(Icons.color_lens),
            subtitle: Text(theme.toCapitalized()),
            onTap: () {
              showModalBottomSheet(
                  elevation: 0,
                  context: context,
                  builder: (context) {
                    return ListView(
                      children: [
                        ListTile(
                          title: const Text("Light"),
                          leading: const Icon(Icons.light_mode),
                          onTap: () {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString("theme", "light");
                              MainApp.of(context)!.updateTheme();
                              setState(() {
                                theme = "light";
                              });
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                        ListTile(
                          title: const Text("Dark"),
                          leading: const Icon(Icons.dark_mode),
                          onTap: () {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString("theme", "dark");
                              MainApp.of(context)!.updateTheme();
                              setState(() {
                                theme = "dark";
                              });
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                        ListTile(
                          title: const Text("System"),
                          leading: const Icon(Icons.settings),
                          onTap: () {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString("theme", "system");
                              MainApp.of(context)!.updateTheme();
                              setState(() {
                                theme = "system";
                              });
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
          ListTile(
            title: const Text("Export"),
            subtitle: const Text("Export all your lists"),
            leading: const Icon(Icons.upload),
            onTap: () {
              Utils.userExportAll();
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

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
