import 'package:boo/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'get_init.dart';
import 'navigation_service.dart';

class ErrorHandler {
  final String message;

  ErrorHandler._(this.message);

  factory ErrorHandler.fromException(Object error) {
    final context = getIt<NavigationService>().navigatorKey.currentContext;

    if (context == null) {
      return ErrorHandler._("Something went wrong");
    }

    final loc = AppLocalizations.of(context)!;

    if (error is PlatformException) {
      if (error.code == 'network_error' ||
          error.message?.contains('unavailable') == true) {
        return ErrorHandler._(loc.noInternet);
      }

      if (error.code == 'sign_in_failed' || error.code == 'sign_in_canceled') {
        return ErrorHandler._(loc.somethingWentWrong);
      }

      return ErrorHandler._(loc.somethingWentWrong);
    }

    if (error is FirebaseException) {
      switch (error.code) {
        case 'user-not-found':
        case 'invalid-credential':
          return ErrorHandler._(loc.noData);

        case 'wrong-password':
          return ErrorHandler._(loc.somethingWentWrong);

        case 'network-request-failed':
          return ErrorHandler._(loc.noInternet);

        case 'account-exists-with-different-credential':
        case 'email-already-in-use':
          return ErrorHandler._(loc.userAlreadyExists);

        default:
          return ErrorHandler._(loc.somethingWentWrong);
      }
    }

    return ErrorHandler._(loc.somethingWentWrong);
  }
}
