import 'package:amplify_flutter/amplify.dart';

import '../models/todo.dart';

class TodosRepository {
  Future<List<Todo>> getTodos(String userId) async {
    try {
      final todos = await Amplify.DataStore.query(Todo.classType,
          where: Todo.USERID.eq(userId));
      return todos;
    } on Exception catch (e) {
      throw TodoError(e);
    }
  }

  Stream observeTodos(String userId) =>
      Amplify.DataStore.observe(Todo.classType);

  Future<void> addTodo(String title, String userId) async {
    final _addedTodo = Todo(userId: userId, title: title, isComplete: false);
    try {
      await Amplify.DataStore.save(_addedTodo);
    } on Exception catch (e) {
      throw TodoError(e);
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      await Amplify.DataStore.delete(todo);
    } on Exception catch (e) {
      throw TodoError(e);
    }
  }

  Future<void> updateTodo(Todo todo, [String title]) async {
    try {
      final updatedTodo = todo.copyWith(
          isComplete: !todo.isComplete, title: title ?? todo.title);
      await Amplify.DataStore.save(updatedTodo);
    } on Exception catch (e) {
      throw TodoError(e);
    }
  }
}

class TodoError implements Exception {
  TodoError(this.exception);

  Exception exception;
}
