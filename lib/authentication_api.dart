import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final ifIsAvaliable = await hasBiometrics();
    if (!ifIsAvaliable) return false;
    try {
      return await _auth.authenticate(
        biometricOnly: true,
        localizedReason: " ",
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: const AndroidAuthMessages(
          signInTitle: "Autenticação",
          biometricHint: "",
          cancelButton: "CANCELAR",
        ),
        // ignore: prefer_const_constructors
        iOSAuthStrings: IOSAuthMessages(
          cancelButton: 'CANCELAR',
          goToSettingsButton: 'configurações',
          goToSettingsDescription: 'Por favor configure o sensor de toque.',
          lockOut: 'Ative seu Touch ID',
        ),
      );
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      List<BiometricType> list = await _auth.getAvailableBiometrics();
      return list;
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }
}
