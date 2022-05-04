import 'package:flutter/material.dart';
import 'package:todo_app_provider/dabasehelper.dart';

class Todo {
  // Properties

  late int id;
  late String title;
  late String description;
  late String isImportant;

  // Constructor
  Todo(
      {required this.id,
      required this.title,
      required this.description,
      required this.isImportant});

  // Todo Copy
  Todo copy(
          {int? id, String? title, String? description, String? isImportant}) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isImportant: isImportant ?? this.isImportant,
      );

  // Get Info In Map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isImportant": isImportant
    };
  }
}

class TodoModel extends ChangeNotifier {
  // Declare Todos in Private
  List<Todo> _todos = [];

  void loadTodos() async {
    _todos = await DatabaseHelper.instance.listAllTodo();
    notifyListeners();
  }

  // Getter
  List<Todo> get items => _todos;

  // Add Todo
  void addTodo(Todo todo) async {
    await DatabaseHelper.instance.addTodo(todo);
    loadTodos();
  }

  /// To Delete Todo By ID
  void deleteTodo(int index) async {
    await DatabaseHelper.instance.deleteTodo(index);
    loadTodos();
  }

  /// To Delete Todo By ID
  void deleteAll() async {
    await DatabaseHelper.instance.deleteAll();
    loadTodos();
  }

  /// Update Todo
  void updateTodo(Todo todo) async {
    await DatabaseHelper.instance.updateTodo(todo);
    loadTodos();
  }
}
