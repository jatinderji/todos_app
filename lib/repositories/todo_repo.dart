import 'dart:developer';

import 'package:todos_app/models/todo.dart';

class TodoRepo {
  List<Todo> todos = List.empty(growable: true);

  List<Todo> getTodos() {
    return todos;
  }

  addTodo(Todo todo) {
    //
    todo.id = todos.length + 1;
    todos.add(todo);
    //
  }

  markTodoCompleted(Todo todo) {
    //
    for (Todo item in todos) {
      if (item.id == todo.id) {
        item.isCompleted = !item.isCompleted;
      }
    }
    //
  }

  delete(Todo todo) {
    //
    todos.removeWhere((element) => element.id == todo.id);
    //
  }

  updateTodo(Todo todo) {
    //
    for (Todo item in todos) {
      if (item.id == todo.id) {
        item.title = todo.title;
        item.desc = todo.desc;
      }
    }
    //
  }

  List<Todo> searchTodo(String title) {
    List<Todo> filteredList = [];
    //
    if (title.isNotEmpty) {
      //
      filteredList = todos
          .where((element) =>
              element.title.toLowerCase().contains(title.toLowerCase()))
          .toList();
      //
    } else {
      return todos;
    }
    //
    return filteredList;
  }
  //
}
