//Repesents a domain level error. Instead of throwing exceptions
//across layers, we return a failure object.This keeps error handling
//explicits and predictable at every layer

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

//Thrown when local storage operation fails
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

//Generic unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
