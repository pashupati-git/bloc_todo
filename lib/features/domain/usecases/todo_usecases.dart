//USE CASES- Each class is a single business actions.
//They are the "verbs " of your app.They orchestrate domain logic
//by calling repository methods. Bloc calls usecases, NOT repositories directly.

//Why separate use cases?
//  - Single responsibility: one class = one action
//  - Testable in isolation (just mock the repository)
// - BloC stays thin- it only handles state, not business logic

import 'package:bloc_todo/core/usecases/usecase.dart';
import 'package:bloc_todo/features/domain/entities/todo.dart';
import 'package:bloc_todo/features/domain/repositories/todo_repository.dart';

//------GetTodos-----------------------------------------------------------
class GetTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;
  GetTodos(this.repository);

  @override
  Future<List<Todo>> call(NoParams params) {
    return repository.getTodos();
  }
}

//------AddTodo-----------------------------------------------------------
class AddTodo implements UseCase<void, AddTodoParams> {
  final TodoRepository repository;
  AddTodo(this.repository);

  @override
  Future<void> call(AddTodoParams params) {
    return repository.addTodo(params.todo);
  }
}

class AddTodoParams {
  final Todo todo;
  const AddTodoParams({required this.todo});
}

//------ToggleTodo-----------------------------------------------------------
class ToggleTodo implements UseCase<void, ToggleTodoParams> {
  final TodoRepository repository;
  ToggleTodo(this.repository);

  @override
  Future<void> call(ToggleTodoParams params) {
    return repository.toggleTodo(params.id);
  }
}

class ToggleTodoParams {
  final String id;
  const ToggleTodoParams({required this.id});
}

//------DeleteTodo-----------------------------------------------------------
class DeleteTodo implements UseCase<void, DeleteTodoParams> {
  final TodoRepository repository;
  DeleteTodo(this.repository);

  @override
  Future<void> call(DeleteTodoParams params) {
    return repository.deleteTodo(params.id);
  }
}

class DeleteTodoParams {
  final String id;
  const DeleteTodoParams({required this.id});
}
