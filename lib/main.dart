import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/pages/root_tabs.dart';
// import 'package:flutter_expense_tracker/widgets/expenses.dart';

void main() {
  runApp(  MaterialApp(
    theme:  ThemeData(useMaterial3: true),
    home: const RootTabs()),
    );
}
