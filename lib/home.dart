import 'package:flutter/material.dart';
import 'package:saveapplication/editNotes.dart';
import 'package:saveapplication/sqldb.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  List notes = [];
  bool isLoading = true;

  Future readData() async {
    List<Map> response = await sqlDb.readData('SELECT * FROM Test');
    notes.addAll(response);
    isLoading = false;
    if (this.mounted) setState(() {});
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Esawy\'s Note'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(
              child: Text("Loading... "),
            )
          : notes.length == 0
              ? Center(
                  child: Text("Write some thing! "),
                )
              : Center(
                  child: ListView(
                    children: [
                      ListView.builder(
                          itemCount: notes.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  child: ListTile(
                                    title: Text(notes[index]['title']),
                                    subtitle: Text(notes[index]['note']),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        int response = await sqlDb.deleteData(
                                            "DELETE FROM Test WHERE id = ${notes[index]['id']}");
                                        if (response > 0)
                                          notes.removeWhere((element) =>
                                              element['id'] ==
                                              notes[index]['id']);
                                        setState(() {});
                                      },
                                      icon:
                                          Icon(Icons.highlight_remove_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditNotes(
                                        note: notes[index]['note'],
                                        id: notes[index]['id'],
                                        title: notes[index]['title'])));
                              },
                            );
                          }),
                      MaterialButton(
                        onPressed: () async {
                          await sqlDb.mydeleteDatebase();
                          notes.clear();
                          setState(() {});
                        },
                        child: Text('delete All Notes'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
