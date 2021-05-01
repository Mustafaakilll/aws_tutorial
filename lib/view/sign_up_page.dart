import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit/auth_cubit.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailCTRL = TextEditingController();
  final TextEditingController _passwordCTRL = TextEditingController();
  final TextEditingController _usernameCTRL = TextEditingController();

  final bool _isVisibleUsernameField = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Giris yap'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: _emailCTRL,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordCTRL,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Visibility(
                visible: _isVisibleUsernameField,
                child: TextField(
                  controller: _usernameCTRL,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).signUp(
                      _usernameCTRL.text,
                      _emailCTRL.text,
                      _passwordCTRL.text,
                    );
                  },
                  child: const Text('Giris yap'))
            ],
          ),
        ),
      );
}
