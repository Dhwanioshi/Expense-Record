import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatted = DateFormat.yMEd();

enum Category { work, leisure, food, travel }

const categoryItem = {
  Category.work: Icons.work,
  Category.food: Icons.lunch_dining_rounded,
  Category.travel: Icons.flight_takeoff_rounded,
  Category.leisure: Icons.movie
};

class ExpenseDets {
  ExpenseDets({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final double amount;
  final String title;
  final Category category;
  final DateTime date;

  String get formattedDate => formatted.format(date);
}

class ExpenseBucket {
  ExpenseBucket({
    required this.category,
    required this.expensess,
  });

  ExpenseBucket.forCategory(
    List<ExpenseDets> allExpense,
    this.category,
  ) : expensess = allExpense
            .where((expense) => category == expense.category)
            .toList();

  final Category category;
  final List<ExpenseDets> expensess;

  double get totalExpense {
    double sum = 0;
    for (final ex in expensess) {
      sum = sum + ex.amount;
    }
    return sum;
  }
}
