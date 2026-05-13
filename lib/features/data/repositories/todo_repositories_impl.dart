//Repository implementation - Bridges the domain and the data layers.
//It implements the domain's TodoRepository interface,but internally.
//calls the data source. It also handles exceptions and converts them.
//to domain Failures so the domain layer stays exception-free.

//Flow: BLoc ->UseCase ->Repository(this) ->DataSource

import 'package:bloc_todo/features/data/datasources/todo_local_datasource.dart';
import 'package:bloc_todo/features/data/models/todo_model.dart';
import 'package:bloc_todo/features/domain/entities/todo.dart';
/// The `import 'package:bloc_todo/features/domain/repositories/todo_repository.dart';` statement in the
/// Dart code is importing the `TodoRepository` interface from the domain layer of the application. This
/// interface defines the contract for interacting with todo-related data in the domain layer. The
/// `TodoRepositoryImpl` class implements this interface, bridging the domain and data layers by
/// providing concrete implementations for methods like `getTodos`, `addTodo`, `toggleTodo`, and
/// `deleteTodo`.
import 'package:bloc_todo/features/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Todo>> getTodos() async {
    //Data sources returns todomodel (data layer type)
    //we return List<Todo>(domain Type)- models already extend entities
    //so this cast is safe. In Larger apps you'd map explicitly.
    final models = await localDataSource.getTodos();
    return models; //TodoModel IS-A Todo (extends it)
  }

  @override
  Future<void> addTodo(Todo todo) async {
    //Convert domain entity -> data model before passing to storage
    final model = TodoModel.fromEntity(todo);
    await localDataSource.saveTodo(model);
  }

  @override
  Future<void> toggleTodo(String id) async {
    await localDataSource.toggleTodo(id);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localDataSource.deleteTodo(id);
  }
}
