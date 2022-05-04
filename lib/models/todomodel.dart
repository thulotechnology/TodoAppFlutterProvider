import 'package:flutter/material.dart';

class Todo {
  // Properties

  late int id;
  late String title;
  late String description;
  late bool isImportant;

  // Constructor
  Todo(
      {required this.id,
      required this.title,
      required this.description,
      required this.isImportant});
}

class TodoModel extends ChangeNotifier {
  // Declare Todos in Private
  List<Todo> _todos = [];

  // Getter
  List<Todo> get items => _todos;

  // Add Todo
  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  // To Remove All Todo Items
  void clearTodo() {
    _todos.clear();
    notifyListeners();
  }

  /// To Delete Todo By ID
  void deleteTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  /// Update Todo
  void updateTodo(int index, Todo todo) {
    _todos[index].title = todo.title;
    _todos[index].description = todo.description;
    notifyListeners();
  }

  // Make Is Not Important
  void changeImportant(int index) {
    _todos[index].isImportant = !_todos[index].isImportant;
    notifyListeners();
  }
}
