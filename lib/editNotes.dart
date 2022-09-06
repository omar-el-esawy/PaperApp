import 'package:flutter/material.dart';
import 'package:saveapplication/sqldb.dart';

import 'home.dart';

class EditNotes extends StatefulWidget {
  final note, title, id;

  const EditNotes({Key? key, this.note, this.title, this.id}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();

  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Esawy\'s Note'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
          child: ListView(
            children: [
              Form(
                key: formstate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: note,
                      decoration:
                          InputDecoration(hintText: "What do you think..."),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: title,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        int response = await sqlDb.updateData('''
                         UPDATE Test SET 
                         note= "${note.text}",
                         title = "${title.text}"
                         WHERE id = ${widget.id}         
                         ''');
                        print(response);
                        if (response > 0)
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (router) => false,
                          );
                      },
                      textColor: Colors.teal,
                      child: Text('Edit Note'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
