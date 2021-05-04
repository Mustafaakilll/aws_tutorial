import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_cubit/auth_cubit.dart';
import 'widget/text_field.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _emailCTRL;
  TextEditingController _passwordCTRL;
  TextEditingController _usernameCTRL;
  final TapGestureRecognizer _onRecognizer = TapGestureRecognizer();

  bool _isVisibleUsernameField = false;

  @override
  void initState() {
    super.initState();
    _emailCTRL = TextEditingController();
    _passwordCTRL = TextEditingController();
    _usernameCTRL = TextEditingController();
    _onRecognizer.onTap = () => setState(() {
          _isVisibleUsernameField = !_isVisibleUsernameField;
        });
  }

  @override
  void dispose() {
    super.dispose();
    _emailCTRL.dispose();
    _passwordCTRL.dispose();
    _usernameCTRL.dispose();
    _onRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.exception),
            ));
          }
        },
        builder: (context, state) => Scaffold(
          appBar: _appBar,
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                CustomTextField(_emailCTRL, 'Email', false),
                const SizedBox(height: 8),
                CustomTextField(_passwordCTRL, 'Şifre', true),
                const SizedBox(height: 8),
                Visibility(
                  visible: _isVisibleUsernameField,
                  child: CustomTextField(_usernameCTRL, 'Kullanıcı Adı', false),
                ),
                ElevatedButton(
                  onPressed: () => _onPressSignInSignUp(state),
                  child: Text(_isVisibleUsernameField ? 'Kayit Ol' : 'Giris yap'),
                ),
                signInUpText()
              ],
            ),
          ),
        ),
      );

  AppBar get _appBar => AppBar(
        title: const Text('Giris yap'),
      );

  void _onPressSignInSignUp(state) {
    debugPrint(state.runtimeType.toString());
    _isVisibleUsernameField
        ? context.read<AuthCubit>().signUp(_usernameCTRL.text, _emailCTRL.text, _passwordCTRL.text)
        : context.read<AuthCubit>().signIn(_emailCTRL.text, _passwordCTRL.text);
  }

  RichText signInUpText() => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.caption,
          text: _isVisibleUsernameField ? 'Hesabiniz Var Mi? ' : 'Hesabiniz Yok Mu? ',
          children: [
            TextSpan(
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blueAccent),
                text: _isVisibleUsernameField ? 'Giris Yap' : 'Kayit Ol',
                recognizer: _onRecognizer)
          ],
        ),
      );
}
