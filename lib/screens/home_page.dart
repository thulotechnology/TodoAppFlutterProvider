import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/models/todomodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allTodos = Provider.of<TodoModel>(context);
    allTodos.loadTodos();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App "),
        actions: [
          ElevatedButton.icon(
              onPressed: () {
                // allTodos.clearTodo();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Do you want to  delete all?"),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                allTodos.deleteAll();
                                Navigator.pop(context);
                              },
                              child: Text("Confirm Delete")),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete),
              label: const Text("Clear")),
          ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.countertops),
              label: Text("Total = ${allTodos.items.length}")),
        ],
      ),
      body: allTodos.items.isEmpty
          ? Center(
              child: Container(
                child: Text(
                  "No Todo Found",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ListView.builder(
              itemCount: allTodos.items.length,
              itemBuilder: (ctx, i) {
                return ListTile(
                  leading: allTodos.items[i].isImportant == "imp"
                      ? GestureDetector(
                          onTap: () {
                            allTodos.updateTodo(Todo(
                                id: allTodos.items[i].id,
                                title: allTodos.items[i].title,
                                description: allTodos.items[i].description,
                                isImportant:
                                    allTodos.items[i].isImportant == "imp"
                                        ? "nimp"
                                        : "imp"));
                          },
                          child: CircleAvatar(
                            child: Icon(
                              Icons.favorite,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            allTodos.updateTodo(Todo(
                                id: allTodos.items[i].id,
                                title: allTodos.items[i].title,
                                description: allTodos.items[i].description,
                                isImportant:
                                    allTodos.items[i].isImportant == "imp"
                                        ? "nimp"
                                        : "imp"));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.favorite_outline_rounded,
                            ),
                          ),
                        ),
                  title: Text(allTodos.items[i].title),
                  subtitle: Text(allTodos.items[i].description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                          color: Colors.brown[900],
                        ),
                        onPressed: () {
                          addOrUpdateDialog(context, false,
                              todo: allTodos.items[i], index: i);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 20.0,
                          color: Colors.brown[900],
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Do you want to  delete?"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          allTodos
                                              .deleteTodo(allTodos.items[i].id);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Confirm Delete")),
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"))
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                );
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            addOrUpdateDialog(context, true);
          }),
    );
  }
}

addOrUpdateDialog(BuildContext context, bool isAdded,
    {Todo? todo, int? index}) {
  TextEditingController cTitle = TextEditingController();
  TextEditingController cDesc = TextEditingController();
  TextEditingController cID = TextEditingController();
  TextEditingController cImp = TextEditingController();

  if (!isAdded) {
    cTitle.text = todo!.title;
    cDesc.text = todo.description;
    cID.text = todo.id.toString();
    cImp.text = todo.isImportant;
  }

  final allTodos = Provider.of<TodoModel>(context, listen: false);
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: isAdded ? Text("Add Todo") : Text("Update Todo"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: cTitle,
          decoration: InputDecoration(labelText: "Title"),
        ),
        TextField(
          controller: cDesc,
          decoration: InputDecoration(labelText: "Description"),
          maxLength: null,
        ),
      ],
    ),
    actions: [
      ElevatedButton(
          onPressed: () {
            if (isAdded) {
              allTodos.addTodo(Todo(
                  id: Random().nextInt(1000),
                  title: cTitle.text,
                  description: cDesc.text,
                  isImportant: ""));
            } else {
              // Update Code
              allTodos.updateTodo(Todo(
                  id: int.parse(cID.text),
                  title: cTitle.text,
                  description: cDesc.text,
                  isImportant: cImp.text));
            }
            Navigator.pop(context);
          },
          child: Text("Save")),
      OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"))
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
