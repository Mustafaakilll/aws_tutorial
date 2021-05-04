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
  TextEditingController _titleCTRL;

  @override
  void initState() {
    super.initState();
    _titleCTRL = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleCTRL.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _appBar,
        body: BlocConsumer<TodoCubit, TodoState>(
          // ignore: void_checks
          listener: (_, state) {
            if (state is TodosErrorState) {
              return _errorView(state.message.toString());
            }
          },
          builder: (context, state) {
            if (state is TodosLoadingState) {
              return _loadingView();
            } else {
              final _state = state as TodosLoadedState;
              final todos = _state.todos;
              return todos.isEmpty ? _emptyTodosView() : todosView(todos);
            }
          },
        ),
        floatingActionButton: _addTodoButton,
      );

  AppBar get _appBar => AppBar(
        title: const Text('Yapılacaklar Listesi'),
        actions: [_appBarPopUp],
      );

  PopupMenuButton<String> get _appBarPopUp => PopupMenuButton(
        onSelected: (value) {
          _popupSelected(value);
        },
        tooltip: 'Daha Fazla',
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'bilgi', child: Text('Bilgi')),
          const PopupMenuItem(value: 'cikisyap', child: Text('Çıkış Yap')),
        ],
      );

  void _popupSelected(String value) {
    switch (value) {
      case 'cikisyap':
        context.read<AuthCubit>().signOut();
        break;
      case 'bilgi':
        _infoDialog();
    }
  }

  void _infoDialog() {
    final _description = <String>[
      'Daha Fazla Seçeneğinin Altından Çıkış yapabilirsin.',
      'Yeni Todo Eklemek İçin Sağ Alttaki Tuşa Basın',
      'Todoyu Silmek İçin Sağdan Sola Kaydır',
      'Todoyu Tamamlamak İçin Üstüne Tıkla'
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _errorView(
          String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  Widget _emptyTodosView() => const Center(
        child: Text('Henüz Todo Eklenmedi'),
      );

  Widget todosView(List<Todo> todos) => ListView.builder(
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Dismissible(
            background: dismissBackground,
            key: Key(todo.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              context.read<TodoCubit>().deleteTodo(todo);
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  _deleteTodoSnackBar(todo),
                );
            },
            child: _todoCard(todo),
          );
        },
        itemCount: todos.length,
      );

  Container get dismissBackground => Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.restore_from_trash_outlined),
        ),
      );

  SnackBar _deleteTodoSnackBar(Todo todo) => SnackBar(
        content: Text('Silinen Todo: ${todo.title}'),
        action: SnackBarAction(
          label: 'Geri Al',
          onPressed: () {
            BlocProvider.of<TodoCubit>(context).addTodo(todo.title);
          },
        ),
      );

  Card _todoCard(Todo todo) => Card(
        elevation: 2,
        child: CheckboxListTile(
          title: Text(todo.title),
          onChanged: (value) {
            context.read<TodoCubit>().updateTodo(todo);
          },
          value: todo.isComplete,
        ),
      );

  FloatingActionButton get _addTodoButton => FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => _newTodoView());
        },
        child: const Icon(Icons.add),
      );

  Widget _newTodoView() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleCTRL,
            decoration: const InputDecoration(hintText: 'Todo'),
          ),
          Flexible(
            flex: 1,
            child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<TodoCubit>(context).addTodo(_titleCTRL.text);
                  _titleCTRL.text = '';
                  Navigator.of(context).pop();
                },
                child: const Text('Kaydet')),
          )
        ],
      );
}
