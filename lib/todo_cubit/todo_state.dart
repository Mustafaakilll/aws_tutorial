part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodosLoadingState extends TodoState {}

class TodosErrorState extends TodoState {
  TodosErrorState(this.message);

  final Exception message;
}

class TodosLoadedState extends TodoState {
  TodosLoadedState(this.todos);

  final List<Todo> todos;
}
