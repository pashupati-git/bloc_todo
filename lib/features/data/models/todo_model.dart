import 'package:bloc_todo/features/domain/entities/todo.dart';

/// The `TodoModel` class extends `Todo` and provides a factory method to convert raw JSON data into a
/// `TodoModel` object.
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.isCompleted,
    required super.createdAt,
  });
  //Convert raw JSON map ->TodoModel(eg , from SharedPreferences or API)
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  //Convert TodoModel -> Json map for (for storing/sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  //Convert a domain entity -> model (eg., when saving a new Todo)
  // When would you use this?
  // You have a pure Todo (from domain layer) but need to SAVE it
  // Domain layer creates Todo, data layer needs TodoModel to call toJson()
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
    );
  }
}
