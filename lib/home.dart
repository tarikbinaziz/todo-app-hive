import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_practise/box.dart';
import 'package:hive_practise/notes%20model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleCon = TextEditingController();
  TextEditingController descCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text("Hive database"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDialouge();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (_, box, widget) {
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var data = box.values.toList();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  _editDialouge(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].desc.toString(),
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                )),
                            IconButton(
                                onPressed: () {
                                  deleteModel(data[index]);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                        Text(data[index].desc.toString()),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Future<void> _showDialouge() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleCon,
                    decoration: InputDecoration(hintText: "title"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descCon,
                    decoration: InputDecoration(hintText: "desc"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel"),
              ),
              TextButton(
                onPressed: () {
                  final data =
                      NotesModel(title: titleCon.text, desc: descCon.text);
                  final box = Boxes.getData();
                  box.add(data);
                  data.save();
                  titleCon.clear();
                  descCon.clear();
                  Navigator.pop(context);
                },
                child: Text("add"),
              ),
            ],
          );
        });
  }

  Future<void> _editDialouge(
      NotesModel notesModel, String title, String desc) async {
    titleCon.text = title;
    descCon.text = desc;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("edit notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleCon,
                    decoration: InputDecoration(hintText: "title"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descCon,
                    decoration: InputDecoration(hintText: "desc"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel"),
              ),
              TextButton(
                onPressed: () async {
                  notesModel.title = titleCon.text.toString();
                  notesModel.desc = descCon.text.toString();
                  await notesModel.save();
                  titleCon.clear();
                  descCon.clear();
                  Navigator.pop(context);
                },
                child: Text("edit"),
              ),
            ],
          );
        });
  }

  deleteModel(NotesModel notesModel) async {
    await notesModel.delete();
  }
}
