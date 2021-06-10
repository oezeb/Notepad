import 'package:flutter/material.dart';

class AppNavigator {
  static void navigateToHome(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  static Future<void> navigateToFavorites(BuildContext context) {
    navigateToHome(context);
    return Navigator.pushNamed(context, '/favorites');
  }
}
