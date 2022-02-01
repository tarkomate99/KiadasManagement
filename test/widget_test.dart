import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_crud/Screens/AddKiadas.dart';
import 'package:hive_crud/Screens/KiadasokList.dart';


void main(){

  testWidgets('textfield', (WidgetTester tester)async{

    await tester.pumpWidget(MaterialApp(home: AddOrUpdateKiadas(false, -1, null)));
    var textField = find.byType(Container);
    expect(textField, findsOneWidget);

  });


}