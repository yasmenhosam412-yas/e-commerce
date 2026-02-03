import 'package:boo/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'get_init.dart';
import 'navigation_service.dart';

class ErrorHandler {
  final String message;

  ErrorHandler._(this.message);

  factory ErrorHandler.fromException(Object error) {
    final context = getIt<NavigationService>().navigatorKey.currentContext!;
    final loc = AppLocalizations.of(context)!;

    if (error is PlatformException) {
      switch (error.code) {
        case 'network_error':
          return ErrorHandler._(loc.noInternet);

        case 'sign_in_failed':
        case 'sign_in_canceled':
          return ErrorHandler._(loc.somethingWentWrong);

        default:
          return ErrorHandler._(loc.somethingWentWrong);
      }
    }

    if (error is FirebaseAuthException) {
      switch (error.code) {
      case 'user-not-found':
      return ErrorHandler._(loc.noData);

      case 'wrong-password':
      return ErrorHandler._(loc.somethingWentWrong);

      case 'invalid-credential':
      return ErrorHandler._(loc.noData);

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
