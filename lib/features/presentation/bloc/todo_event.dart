//Bloc events - These are the 'intentions'/'actions' the Ui can fire.
//Think of them as commands : "I want X to happen"
//The bloc Listens for these and produces new States in response.
//
//All Events extend Equatable so the Bloc can compare them
//and avoid duplicate processing if needed.

//Base class -all events inherit fo=rom this
import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

//Fired when the page first loads to fetch all todos
class LoadTodosEvent extends TodoEvent {
  const LoadTodosEvent();
}

//Fired when user submits a new todo title
class AddTodoEvent extends TodoEvent {
  final String title;
  const AddTodoEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

//Fired when user toggles a todo's completion status
class ToggleTodoEvent extends TodoEvent {
  final String id;
  const ToggleTodoEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

//Fired when user deletes a todo
class DeleteTodoEvent extends TodoEvent {
  final String id;
  const DeleteTodoEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
