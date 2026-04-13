//Local data source- The lowest layer; directly touches storage
//In a real app this could be sharedpreferences, sqlite,hive,etc.
//here we use an in-memory list to keep the example dependency -free

//The repository clls this. Bloc never touches this directly

import 'package:bloc_todo/features/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> saveTodo(TodoModel todo);
  Future<void> toggleTodo(String id);
  Future<void> deleteTodo(String id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  //Simulated in-memory 'database'
  final List<TodoModel> _todos = [];

  @override
  Future<List<TodoModel>> getTodos() async {
    //Simulate async I/O delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_todos);
  }

  @override
  Future<void> saveTodo(TodoModel todo) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _todos.add(todo);
  }

  @override
  Future<void> toggleTodo(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final existing = _todos[index];
      //Models are immutable - replace with updated copy
      _todos[index] = TodoModel(
        id: existing.id,
        title: existing.title,
        isCompleted: !existing.isCompleted, //<-flip the flag
        createdAt: existing.createdAt,
      );
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _todos.removeWhere((t) => t.id == id);
  }
}
