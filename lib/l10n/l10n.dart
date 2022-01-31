import 'dart:ui';

class L10n{

  static final all = [
    const Locale('en'),
    const Locale('hu')
  ];

  static String getFlag(String code){
    switch (code){
      case 'en':
        return '🇬🇧';
      case 'hu':
        return '🇭🇺';
      default:
        return '';
    }
  }
}