//Repository interface (contract) - Lives in the domain layer.
//The domain layer defines WHAT operations are possible.
//The data layer defines HOW they are implemented.

//The inversion is the heart of clean architecture.
//Domain does Not depend on Data. Data depends on Domain.

import 'package:bloc_todo/features/domain/entities/todo.dart';

abstract class TodoRepository {
  //Fetch all the todos from storage

  Future<List<Todo>> getTodos(
  );

  ///Persist a new todo
  Future<void> addTodo(Todo todo);

  //Flip the isCompleted flag of a todo
  Future<void> toggleTodo(String id);

  //Remove a todo by ID
  Future<void> deleteTodo(String id);
}
