import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class AuthRepository {
  ///GET USER ID
  Future<String> fetchUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final subAttribute =
          attributes.firstWhere((element) => element.userAttributeKey == 'sub');
      final userId = subAttribute.value;
      return userId;
    } on Exception catch (e) {
      throw AuthError(e);
    }
  }

  /// Signup a User
  Future<bool> signUp(String username, String email, String password) async {
    try {
      final userAttributes = <String, String>{
        'email': email,
        'preferred_username': username
      };
      //NOTE:TODO:USERNAME ILE GIRIS DENE
      final res = await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      return res.isSignUpComplete;
    } on Exception catch (e) {
      throw AuthError(e);
    }
  }

  /// Confirm User
  Future<bool> confirm(String username, String confirmationCode) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
          username: username, confirmationCode: confirmationCode);
      return res.isSignUpComplete;
    } on Exception catch (e) {
      throw AuthError(e);
    }
  }

  /// Signin a User
  Future<String> signIn(String username, String password) async {
    try {
      final res =
          await Amplify.Auth.signIn(username: username, password: password);
      if (res.isSignedIn) {
        return await fetchUserIdFromAttributes();
      } else {
        throw Exception('could not sign in');
      }
    } on Exception catch (e) {
      throw AuthError(e);
    }
  }

  ///SIGN OUT USER
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on Exception catch (e) {
      throw AuthError(e);
    }
  }

  /// Auto sign in
  Future<String> attemptAutoSignIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        return await fetchUserIdFromAttributes();
      } else {
        throw Exception('Not signed in');
      }
    } on Exception catch (e) {
      throw AuthError(e);
    }
  }
}

class AuthError implements Exception {
  AuthError(this.exception);

  final Exception exception;
}
