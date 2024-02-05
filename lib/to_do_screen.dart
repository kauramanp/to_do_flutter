import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:to_do_flutter/to_do_model.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  var list = <String>["Testing"];
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  _showPopUpDialog({int position = -1}) {
    var textFieldController = TextEditingController();
    var _validate = false;
    if (position > -1) {
      textFieldController.text = list[position];
    }
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, alertState) {
            return AlertDialog(
              title: Text(position > -1 ? "Update Item" : "Add Item"),
              content: TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                    labelText: "Enter the value",
                    errorText: _validate ? "Enter value" : null),
              ),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      if (textFieldController.text.isEmpty) {
                        _validate = textFieldController.text.isEmpty;
                        alertState(() {});
                        return;
                      } else if (position > -1) {
                        list[position] = textFieldController.text.toString();
                      } else {
                        var toDoModel =
                            ToDoModel(textFieldController.text.toString());

                        list.add(textFieldController.text.toString());
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Text(
                        position > -1 ? "Update List Item" : "Add In List"))
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to ToDo App")),
      body: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  _showPopUpDialog(position: index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    list[index],
                    style: TextStyle(fontSize: 35),
                  ),
                ));
          },
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPopUpDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
