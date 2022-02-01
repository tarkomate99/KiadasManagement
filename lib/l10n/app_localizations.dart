import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_crud/l10n/en.dart';
import 'package:hive_crud/l10n/hu.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Map<String, Map<String, String>> _localizedValues = {
    'en': ENGLISH_TEXTS,
    'hu': HUNGARIAN_TEXTS
  };

  String stringById(String id) =>
      _localizedValues[locale.languageCode]?[id] ??
      'Missing translation: $id for locale: ${locale.languageCode}';

  String get expenditures => stringById('expenditures');
  String get opinions => stringById('opinions');
  String get managementapp => stringById('managementapp');
  String get explist => stringById('explist');
  String get date => stringById('date');
  String get place => stringById('place');
  String get expenditure => stringById('expenditure');
  String get withwho => stringById('withwho');
  String get receipt => stringById('receipt');
  String get search => stringById('search');
  String get contactlist => stringById('contactlist');
  String get camera => stringById('camera');
  String get upload => stringById('upload');
  String get youropinion => stringById('youropinion');
  String get send => stringById('send');
  String get add => stringById('add');
  String get modify => stringById('modify');
  String get addopinion => stringById('addopinion');
  String get welcome => stringById('welcome');
  String get description => stringById('description');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hu'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      AppLocalizations(locale),
    );
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
