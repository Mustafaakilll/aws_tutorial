import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../auth_cubit/auth_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(UnknownState());

  final AuthRepository _authRepository = AuthRepository();

  void signUp(String username, String email, String password) async {
    try {
      final isSignup = await _authRepository.signUp(username, email, password);
      if (isSignup) {
        emit(ConfirmState(email));
      } else {
        emit(UnauthenticatedState());
      }
    } on AuthError catch (e) {
      emit(ErrorAuthState(e));
    }
  }

  Future<void> confirmAccount(String username, String confirmationCode) async {
    try {
      final _isConfirmed =
          await _authRepository.confirm(username, confirmationCode);
      if (_isConfirmed) {
        emit(UnauthenticatedState());
      }
    } on AuthError catch (e) {
      emit(ErrorAuthState(e));
    }
  }

  void signIn(String username, String password) async {
    try {
      final userId = await _authRepository.signIn(username, password);
      if (userId != null && userId.isNotEmpty) {
        emit(AuthenticatedState(userId));
      } else {
        emit(UnauthenticatedState());
      }
    } on AuthError catch (e) {
      emit(ErrorAuthState(e));
    }
  }

  void signOut() async {
    try {
      await _authRepository.signOut();
      emit(UnauthenticatedState());
    } on AuthError catch (e) {
      emit(ErrorAuthState(e));
    }
  }

  void attemptAutoSignIn() async {
    try {
      final userId = await _authRepository.attemptAutoSignIn();
      if (userId != null && userId.isNotEmpty) {
        emit(AuthenticatedState(userId));
      } else {
        emit(UnauthenticatedState());
      }
    } on AuthError catch (e) {
      emit(ErrorAuthState(e));
    }
  }
}
