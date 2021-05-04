import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthRepository {
  ///GET USER ID
  Future<String> fetchUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final subAttribute = attributes.firstWhere((element) => element.userAttributeKey == 'sub');
      final userId = subAttribute.value;
      return userId;
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'CodeExpiredException':
        case 'CognitoCodeExpiredException':
          throw AuthError('Doğrulama Kodunun Süresi Geçmiş');
        case 'CodeMismatchException':
          throw AuthError('Hatalı Kod Girdiniz');
        case 'InvalidPasswordException':
          throw AuthError('Hatalı Şifre Girdiniz');
        case 'TooManyFailedAttemptsException':
          throw AuthError('Çok Fazla Sayıda Hatalı Giriş Yaptınız');
        case 'UsernameExistsException':
          throw AuthError('Bu Kullanıcı Adı Kullanılmaktadır.');
        case 'UserNotConfirmedException':
          throw AuthError('Kullanıcı Henüz Doğrulanmadı.');
        case 'UserNotFoundException':
          throw AuthError('Kullanıcı Bulunamadı. Lütfen Bilgileriniz Kontrol Edin.');
        default:
          throw AuthError(e.details);
      }
    }
  }

  /// Signup a User
  Future<bool> signUp(String username, String email, String password) async {
    try {
      final userAttributes = <String, String>{'email': email, 'preferred_username': username};
      final res = await Amplify.Auth.signUp(
          username: email, password: password, options: CognitoSignUpOptions(userAttributes: userAttributes));

      return res.isSignUpComplete;
    } on Exception catch (e) {
      if (e.runtimeType.toString().contains('UsernameExistsException')) {
        throw AuthError('Bu Kullanıcı Adı Kullanılmaktadır.');
      } else {
        throw AuthError(e.runtimeType.toString());
      }
    }
  }

  /// Confirm User
  Future<bool> confirm(String username, String confirmationCode) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(username: username, confirmationCode: confirmationCode);
      return res.isSignUpComplete;
    } on Exception catch (e) {
      if (e.runtimeType.toString().contains('CodeExpiredException')) {
        throw AuthError('Doğrulama Kodunun Süresi Geçmiş.');
      } else if (e.runtimeType.toString().contains('CognitoCodeExpiredException')) {
        throw AuthError('Doğrulama Kodunun Süresi Geçmiş.');
      } else if (e.runtimeType.toString().contains('CodeMismatchException')) {
        throw AuthError('Hatali Kod Girdiniz.');
      } else if (e.runtimeType.toString().contains('InvalidPasswordException')) {
        throw AuthError('Hatalı Şifre Girdiniz.');
      } else if (e.runtimeType.toString().contains('TooManyFailedAttemptsException')) {
        throw AuthError('Çok Fazla Sayıda Hatalı Giriş Yaptınız');
      } else if (e.runtimeType.toString().contains('TooManyFailedAttemptsException')) {
        throw AuthError('Çok Fazla Sayıda Hatalı Giriş Yaptınız');
      } else {
        throw AuthError(e.runtimeType.toString());
      }
    }
  }

  /// Signin a User
  Future<String> signIn(String username, String password) async {
    try {
      final res = await Amplify.Auth.signIn(username: username, password: password);
      if (res.isSignedIn) {
        return await fetchUserIdFromAttributes();
      } else {
        throw Exception('could not sign in');
      }
    } on Exception catch (e) {
      debugPrint('GIRIS YAPARKEN GELEN HATA ${e.runtimeType} GELEN HATA GIRIS YAPARKEN');
      if (e.runtimeType.toString().contains('UserNotFoundException')) {
        throw AuthError('Kullanici Bulunamadi. Lutfen bilgilerinizi kontrol edin.');
      } else if (e.runtimeType.toString().contains('TooManyFailedAttemptsException')) {
        throw AuthError('Cok fazla hatali deneme yaptiniz. Daha sonra deneyin.');
      } else if (e.runtimeType.toString().contains('InvalidPasswordException')) {
        throw AuthError('Sifreniz hatali gorunuyor. Lutfen kontrol et.');
      } else if (e.runtimeType.toString().contains('NotAuthorizedException')) {
        throw AuthError('Bir seyleri yanlis girdiniz. Lutfen kontrol edin.');
      } else if (e.runtimeType.toString().contains('UserNotConfirmedException')) {
        throw AuthError('Kullanici henuz dogrulanmadi. Lutfen gelistirici ile iletisime gecin');
      } else {
        throw AuthError(e.runtimeType.toString());
      }
    }
  }

  ///SIGN OUT USER
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on Exception catch (e) {
      throw AuthError(e.runtimeType.toString());
    }
  }

  /// Auto sign in
  Future<String> attemptAutoSignIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        return await fetchUserIdFromAttributes();
      } else {
        throw AuthError('Giris Yapilmadi');
      }
    } on Exception catch (e) {
      throw AuthError(e.runtimeType.toString());
    }
  }
}

class AuthError implements Exception {
  AuthError(this.details);

  final String details;
}
