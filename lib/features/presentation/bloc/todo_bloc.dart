//
// The Bloc - The brain of the presentation layer.
// It receives Events, calls Use Cases, and emits new States.
//
//Bloc knows about : Use Cases (domain layer)
//bloc does not know about : DataSources, Models , or Widgets
//
//This is the key separation : Ui -> Bloc -> UseCase -> Repository -> DataSource

import 'dart:async';

import 'package:bloc_todo/core/usecases/usecase.dart';
import 'package:bloc_todo/features/domain/entities/todo.dart';
import 'package:bloc_todo/features/domain/usecases/todo_usecases.dart';
import 'package:bloc_todo/features/presentation/bloc/todo_event.dart';
import 'package:bloc_todo/features/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final ToggleTodo toggleTodo;
  final DeleteTodo deleteTodo;

  /// reused throughout the lifecycle of the `TodoBloc` class. This instance of `Uuid` will be used to
  /// generate unique identifiers for new todo items created within the `TodoBloc`.
  final _uuid = const Uuid();

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.toggleTodo,
    required this.deleteTodo,
  }) : super(const TodoInitial()) {
    //Register one handler per event type.
    on<LoadTodosEvent>(_onloadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  //---Handlers--------------------------------------------------

  Future<void> _onloadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoLoading()); //Tell UI: "I'm working"
    try {
      final todos = await getTodos(NoParams());
      emit(TodoLoaded(todos: todos)); //Tell UI: "Here's the data"
    } catch (e) {
      emit(TodoError(message: e.toString())); //Tell UI: "Something broke"
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    //Build the new Todo entity right here in the Bloc
    final newTodo = Todo(
      id: _uuid.v4(), //Generate unique ID
      title: event.title,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    try {
      await addTodo(AddTodoParams(todo: newTodo));
      //After successfull addition, reload the list to show the new todo
      final updatedTodos = await getTodos(NoParams());
      emit(TodoLoaded(todos: updatedTodos));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await toggleTodo(ToggleTodoParams(id: event.id));
      //After successfull toggle, reload the list to show the updated todo
      final updatedTodos = await getTodos(NoParams());
      emit(TodoLoaded(todos: updatedTodos));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await deleteTodo(DeleteTodoParams(id: event.id));
      //After successfull deletion, reload the list to show the updated todo
      final updatedTodos = await getTodos(NoParams());
      emit(TodoLoaded(todos: updatedTodos));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }
}
