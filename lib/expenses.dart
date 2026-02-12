import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 20,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 12.45,
      date: DateTime.now(),
      category: Category.leisure,
    ),    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text('The chart')]));
  }
}
