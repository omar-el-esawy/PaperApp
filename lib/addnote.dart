import 'package:flutter/material.dart';
import 'package:saveapplication/sqldb.dart';

import 'home.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();

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
                        int response = await sqlDb.insertData('''
                         INSERT INTO Test(note ,title) 
                         VALUES("${note.text}", "${title.text}")          
                         ''');
                        print(response);
                        if (response > 0)
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (router) => false,
                          );
                      },
                      textColor: Colors.teal,
                      child: Text('Add Note'),
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
