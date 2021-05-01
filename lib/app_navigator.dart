import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit/auth_cubit.dart';
import 'todo_cubit/todo_cubit.dart';
import 'view/confirm_page.dart';
import 'view/loading_view.dart';
import 'view/sign_in_page.dart';
import 'view/todo_page.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => Navigator(
          pages: [
            if (state is UnknownState) MaterialPage(child: LoadingView()),
            if (state is ConfirmState)
              MaterialPage(child: ConfirmPage(state.username)),
            if (state is UnauthenticatedState)
              MaterialPage(child: SignInPage()),
            if (state is ErrorAuthState) MaterialPage(child: SignInPage()),
            if (state is AuthenticatedState)
              MaterialPage(
                child: BlocProvider(
                  create: (context) => TodoCubit(state.userId)
                    ..getTodos()
                    ..observeTodos(),
                  child: TodoPage(),
                ),
              ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        ),
      );
}
