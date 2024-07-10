import 'package:flutter/material.dart';
import 'package:voclearner/models/voc.dart';
import 'package:voclearner/pages_layout.dart';
import 'package:voclearner/services/database.dart';
import 'package:voclearner/widgets/voc_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Voc> vocs = [];

  void loadVocs() {
    DatabaseService.getVocs().then((value) {
      setState(() {
        vocs = value;
      });
    });
  }

  @override
  void initState() {
    loadVocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VocLearner"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            title: Text(vocs[index].title ?? ""),
            subtitle: Text(vocs[index].description ?? ""),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PagesLayout(
                        displayNavBar: false,
                        child: VocDetailsPage(
                          voc: vocs[index],
                        ))),
              );
            },
          );

          // GestureDetector(
          //     onTap: () {},
          //     child: Card(
          //         child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Column(
          //               children: [
          //                 Text(vocs[index].title ?? ""),
          //                 Text(vocs[index].description ?? "")
          //               ],
          //             ))));
        },
        itemCount: vocs.length,
      ),
    );
  }
}
