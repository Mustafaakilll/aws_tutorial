import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit/auth_cubit.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailCTRL = TextEditingController();
  final TextEditingController _passwordCTRL = TextEditingController();
  final TextEditingController _usernameCTRL = TextEditingController();

  bool _isVisibleUsernameField = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Giris yap'),
        ),
        body: Column(
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
            TextField(
              controller: _passwordCTRL,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Sifre',
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
                // context.read<AuthCubit>().signOut();
                context
                    .read<AuthCubit>()
                    .signIn(_emailCTRL.text, _passwordCTRL.text);
              },
              child: const Text('Giris yap'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isVisibleUsernameField = !_isVisibleUsernameField;
                });
              },
              child: Text(_isVisibleUsernameField ? 'Giris Yap' : 'Kayit Ol'),
            ),
          ],
        ),
      );
}
