import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_crud/Screens/AddKiadas.dart';
import 'package:hive_crud/Screens/ContactList.dart';
import 'package:hive_crud/Screens/KiadasokList.dart';

void main() {
  testWidgets('textfield', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactList());
    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
  });
}
