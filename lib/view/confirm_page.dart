import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit/auth_cubit.dart';

class ConfirmPage extends StatelessWidget {
  ConfirmPage(this.username, {Key key}) : super(key: key);

  final String username;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _controller,
              ),
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context)
                        .confirmAccount(username, _controller.text);
                  },
                  child: const Text('Hesabu onayla')),
            ],
          ),
        ),
      );
}
