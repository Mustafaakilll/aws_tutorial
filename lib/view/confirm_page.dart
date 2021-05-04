import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit/auth_cubit.dart';
import 'widget/text_field.dart';

class ConfirmPage extends StatelessWidget {
  ConfirmPage(this.username, {Key key}) : super(key: key);

  final String username;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.exception),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: _appBar,
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                children: [
                  CustomTextField(_controller, 'Onay Kodu', false),
                  const SizedBox(height: 8),
                  confirmButton(context),
                ],
              ),
            ),
          ),
        ),
      );

  ElevatedButton confirmButton(BuildContext context) => ElevatedButton(
        onPressed: () => context
            .read<AuthCubit>()
            .confirmAccount(username, _controller.text),
        child: const Text('Hesabı onayla'),
      );

  AppBar get _appBar => AppBar(title: const Text('Hesabınızı Onaylayın'));
}
