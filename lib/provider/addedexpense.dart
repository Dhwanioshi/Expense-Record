import 'package:expense_record/models/expense_dits.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as syspath;
import 'package:sqflite/sqlite_api.dart';

class AddExpenseNotifier extends StateNotifier<List<ExpenseDets>> {
  AddExpenseNotifier() : super(const []);

  Future<Database> getDatabase() async {
    final dbpath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbpath, 'expenses.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expense_record(id TEXT PRIMARY KEY, amount REAL, date TEXT, title TEXT, category TEXT)',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadExpense() async {
    final db = await getDatabase();
    final data = await db.query('expense_record');
    final expenses = data.map((tuple) {
      return ExpenseDets(
        id: tuple['id'] as String,
        amount: tuple['amount'] as double,
        date: DateTime.parse(tuple['date'] as String),
        title: tuple['title'] as String,
        category: Category.values.firstWhere(
            (element) => element.toString() == 'Category.${tuple['category']}'),
      );
    }).toList();
    state = expenses;
  }

  void onAdding(double amount, String title, DateTime date, Category category,
      {int? index}) async {
    final newExpense = ExpenseDets(
      amount: amount,
      date: date,
      title: title,
      category: category,
    );
    final db = await getDatabase();
    db.insert(
      'expense_record',
      {
        'id': newExpense.id,
        'amount': newExpense.amount,
        'category': newExpense.category.name,
        'title': newExpense.title,
        'date': newExpense.date.toIso8601String(),
      },
    );
    if (index == null) {
      state = [
        newExpense,
        ...state,
      ];
    } else {
      final insertionCopy = List<ExpenseDets>.from(state);
      insertionCopy.insert(index, newExpense);
      state = insertionCopy;
    }
  }

  void onEditing(
    String id,
    double amount,
    String title,
    DateTime date,
    Category category,
  ) async {
    final db = await getDatabase();
    db.update(
      "expense_record",
      {
        "id"
            'amount': amount,
        'category': category.name,
        'title': title,
        'date': date.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> onDeleting(ExpenseDets del) async {
    final db = await getDatabase();
    db.delete(
      'expense_record',
      where: 'id = ?',
      whereArgs: [del.id],
    );
  }
}

final addExpenseProvider =
    StateNotifierProvider<AddExpenseNotifier, List<ExpenseDets>>((ref) {
  return AddExpenseNotifier();
});
