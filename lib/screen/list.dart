import 'package:expense_record/models/expense_dits.dart';
import 'package:expense_record/provider/addedexpense.dart';
import 'package:expense_record/screen/new_expense.dart';
import 'package:expense_record/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:state_notifier/state_notifier.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  late List<ExpenseDets> expenseList;
  late Future<void> loadExpenseList;

  @override
  void initState() {
    super.initState();
    loadExpenseList = ref.read(addExpenseProvider.notifier).loadExpense();
  }

  void deliting(ExpenseDets del) {
    final indexOf = expenseList.indexOf(del);
    // final currentExpenses = ref.read(addExpenseProvider);

    setState(() {
      expenseList.remove(del);
    });
    ref.watch(addExpenseProvider.notifier).onDeleting(del);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Expense Deleted"),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            ref.watch(addExpenseProvider.notifier).onAdding(
                del.amount, del.title, del.date, del.category,
                index: indexOf);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    expenseList = ref.watch(addExpenseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paisa hi Paisa hai!!'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewExpense(
                    expense: null,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            "Your Expenses",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          Expanded(
            child: FutureBuilder(
              future: loadExpenseList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (expenseList.isNotEmpty) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NewExpense(
                              expense: expenseList[0],
                            );
                          },
                        ),
                      );
                    },
                    child: Lists(
                      expenseList: expenseList,
                      onDismissed: deliting,
                    ),
                  );
                }
                return Center(
                  child: Text(
                    "No Expenses Yet",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
