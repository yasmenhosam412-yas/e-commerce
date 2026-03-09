import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  LocaleCubit() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = await _storage.read(key: 'languageCode');
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    await _storage.write(key: 'languageCode', value: languageCode);
    emit(Locale(languageCode));
  }

  Future<void> toggleLanguage() async {
    final newLocale = state.languageCode == 'en' ? 'ar' : 'en';
    await changeLanguage(newLocale);
  }
}
