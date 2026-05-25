//Dependency injection -Wires everything together using get_it (service locator).
//This is the only place in the app where concrete classes are referenced together.
//Everything else depends on abstractions (interfaces).
//
//Registration order matters: register dependencies before dependents
// DataSource -> Repository -> UseCases ->BLoc

import 'package:bloc_todo/features/data/datasources/todo_local_datasource.dart';
import 'package:bloc_todo/features/data/repositories/todo_repositories_impl.dart';
import 'package:bloc_todo/features/domain/repositories/todo_repository.dart';
import 'package:bloc_todo/features/domain/usecases/todo_usecases.dart';
import 'package:bloc_todo/features/presentation/bloc/todo_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {

  
  //==========1.Data Sources===============================
  //registerLazySingleton: created once, reused everywhere (same instance)
 /// This code snippet is registering a lazy singleton instance of `TodoLocalDataSourceImpl` class with
 /// the `GetIt` service locator (`sl`).
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(),
  );

  //==========2.Repositories=====================
  //registers the interface (TodoRepository) but constructs the implementation
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(localDataSource: sl()),
    //sl() auto-resolves TodoLocalDataSource registered above.
  );

  //==========3.Use Cases===============
/// These lines of code are registering lazy singletons for the use case classes `GetTodos`, `AddTodo`,
/// `ToggleTodo`, and `DeleteTodo` with the `GetIt` service locator (`sl`).
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => ToggleTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));

  //==========4.BLoc==============================
  // registerFactory: creates a NEW instance each time its requested.
  // Blocs should be factories so each screen gets a fresh state.
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      addTodo: sl(),
      toggleTodo: sl(),
      deleteTodo: sl(),
    ),
  );
}
