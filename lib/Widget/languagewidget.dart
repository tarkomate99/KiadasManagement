import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_crud/l10n/l10n.dart';

class LanguageWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final locale = Localizations.localeOf(context);


    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Container(width: 12,),
        items: L10n.all.map(
            (locale){
              final flag = L10n.getFlag(locale.languageCode);
              return DropdownMenuItem(
                child: Center(
                  child: Text(
                    flag,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                value: locale,
              );
            },
        ).toList(),
        onChanged: (_){},
      ),
    );

  }


}