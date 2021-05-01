import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit/auth_cubit.dart';
import '../models/todo.dart';
import '../todo_cubit/todo_cubit.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _titleCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _navBar(),
        body: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            if (state is TodosLoadingState) {
              return _loadingView();
            } else if (state is TodosErrorState) {
              return _errorView(state.message.toString());
            } else {
              final _state = state as TodosLoadedState;
              final todos = _state.todos;
              return todos.isEmpty ? _emptyTodosView() : todosView(todos);
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context, builder: (context) => _newTodoView());
          },
          child: const Icon(Icons.add),
        ),
      );

  AppBar _navBar() => AppBar(
        title: const Text('Yapilacaklar Listesi'),
        leading: _logOutButton,
        actions: [
          IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _infoDialog();
              })
        ],
      );

  IconButton get _logOutButton => IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          BlocProvider.of<AuthCubit>(context).signOut();
        },
      );

  void _infoDialog() {
    final _description = <String>[
      'Çıkış Yapmak Icin Sol Üstteki Tuşa Basın',
      'Yeni Todo Eklemek Icin Sağ Alttaki Tuşa Basın',
      'Todoyu Silmek Icin Sağdan Sola Kaydır',
      'Todoyu Tamamlamak Icin Üstüne Tıkla'
    ];
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Genel Bilgilendirme'),
        content: ListView.builder(
          shrinkWrap: true,
          itemCount: _description.length,
          itemBuilder: (context, index) => Text('\n\n${_description[index]}'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Geri gel'),
          ),
        ],
      ),
    );
  }

  Widget _loadingView() => const Center(child: CircularProgressIndicator());

  Widget _errorView(String message) => Center(child: Text(message));

  Widget todosView(List<Todo> todos) => ListView.builder(
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Dismissible(
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.restore_from_trash_outlined),
              ),
            ),
            key: Key(todo.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              context.read<TodoCubit>().deleteTodo(todo);
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Silinen Todo: ${todo.title}'),
                    action: SnackBarAction(
                      label: 'Geri Al',
                      onPressed: () {
                        context.read<TodoCubit>().addTodo(todo.title);
                      },
                    ),
                  ),
                );
            },
            child: Card(
              elevation: 2,
              child: CheckboxListTile(
                title: Text(todo.title),
                onChanged: (value) {
                  context.read<TodoCubit>().updateTodo(todo);
                },
                value: todo.isComplete,
              ),
            ),
          );
        },
        itemCount: todos.length,
      );

  Widget _emptyTodosView() => const Center(
        child: Text('No todos yet'),
      );

  Widget _newTodoView() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleCTRL,
            decoration: const InputDecoration(hintText: 'Todo Basligi'),
          ),
          Flexible(
            flex: 1,
            child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<TodoCubit>(context).addTodo(_titleCTRL.text);
                  _titleCTRL.text = '';
                  Navigator.of(context).pop();
                },
                child: const Text('Save Todo')),
          )
        ],
      );
}
