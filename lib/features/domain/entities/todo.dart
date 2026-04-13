//Domain entity-the purest form of our data
//no json parsing , no flutter imports , no database fields
//just the business concept of what is.
//extends equatable so two todo objects with the same data are equal.

import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  //copyWith lets us create a new Todo with some fields changed.
  //This keeps our entity immutable(never mutate,always return new).
  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, createdAt];
}
