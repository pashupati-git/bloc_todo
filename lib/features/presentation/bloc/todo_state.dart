//Bloc states- These represents the UI's possible conditions at any moment.
//The Ui rebuilds whenever a new state is emitted.

//Pattern used: sealed state classes (one per condition)
//Aternative :single state class with status enum - both are valid

//Base class -Ui always holds a todostate
import 'package:bloc_todo/features/domain/entities/todo.dart';
import 'package:equatable/equatable.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

//Initial state - before any events is fired
class TodoInitial extends TodoState {
  const TodoInitial();
}

//While async operations (fetch/add/toggle/delete) are in progress
class TodoLoading extends TodoState {
  const TodoLoading();
}

//Sucessfully loaded todos - carries the list the UI needs
class TodoLoaded extends TodoState {
  final List<Todo> todos;
  const TodoLoaded({required this.todos});

  //Derived getters - computed properties the Ui can use
  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.isCompleted).length;
  int get pendingCount => todos.where((t) => !t.isCompleted).length;

  @override
  List<Object?> get props => [todos];
}

//Something went wrong - carries a human-readable message
class TodoError extends TodoState {
  final String message;
  const TodoError({required this.message});

  @override
  List<Object?> get props => [message];
}
