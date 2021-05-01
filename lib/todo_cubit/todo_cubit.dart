import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/todo.dart';
import 'todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this.userId) : super(TodosLoadingState());

  String userId;

  final TodosRepository _todosRepo = TodosRepository();

  Future<void> getTodos() async {
    try {
      final todos = await _todosRepo.getTodos(userId);
      emit(TodosLoadedState(todos));
    } on TodoError catch (e) {
      emit(TodosErrorState(e.exception));
    }
  }

  void observeTodos() {
    try {
      _todosRepo.observeTodos(userId).listen((_) => getTodos());
    } on TodoError catch (e) {
      emit(TodosErrorState(e.exception));
    }
  }

  void addTodo(String title) async {
    try {
      await _todosRepo.addTodo(title, userId);
    } on TodoError catch (e) {
      emit(TodosErrorState(e.exception));
    }
  }

  void deleteTodo(Todo todo) async {
    try {
      await _todosRepo.deleteTodo(todo);
    } on TodoError catch (e) {
      emit(TodosErrorState(e.exception));
    }
  }

  void updateTodo(Todo todo, [String title]) async {
    try {
      await _todosRepo.updateTodo(todo.copyWith(userId: userId));
    } on TodoError catch (e) {
      emit(TodosErrorState(e.exception));
    }
  }
}
