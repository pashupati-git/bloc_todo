//A contract every usecase must follow
//Type[T]=returns type, Type[Params]=input parameters
//Using a sealed Either-like patterns: returns the result or a failure

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

//Used when usecases needs no parameters

class NoParams {}
