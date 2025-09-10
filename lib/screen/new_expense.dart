// import 'package:expense_record/expenses.dart';
// import 'package:expense_record/expenses.dart';

import 'package:expense_record/provider/addedexpense.dart';
import 'package:flutter/material.dart';
import 'package:expense_record/models/expense_dits.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewExpense extends ConsumerStatefulWidget {
  const NewExpense({super.key, this.expense});
  final ExpenseDets? expense;
  @override
  ConsumerState<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends ConsumerState<NewExpense> {
  final saveChangeText = TextEditingController();
  final saveChangeAmount = TextEditingController();
  DateTime? pickedDateFinal;
  DateTime initDateval = DateTime.now();
  Category valueCate = Category.food;

  void dateSelected() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initDateval,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    setState(() {
      pickedDateFinal = pickedDate;
      initDateval = pickedDate!;
    });
  }

  void saveExpense() {
    final checkAmount = double.tryParse(saveChangeAmount.text);
    final amoutInvalid = checkAmount == null || checkAmount <= 0;
    if (saveChangeText.text.trim().isEmpty ||
        amoutInvalid ||
        pickedDateFinal == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Data"),
          content: const Text("The data in invalid. Please enter valid data."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Try Again"),
            ),
          ],
        ),
      );
      return;
    }
    if (widget.expense != null) {
      ref.read(addExpenseProvider.notifier).onEditing(
            widget.expense!.id,
            checkAmount,
            saveChangeText.text,
            pickedDateFinal!,
            valueCate,
          );
    } else {
      ref.read(addExpenseProvider.notifier).onAdding(
            checkAmount,
            saveChangeText.text,
            pickedDateFinal!,
            valueCate,
          );
    }

    Navigator.pop(context);
    return;
  }

  @override
  void dispose() {
    saveChangeText.dispose();
    saveChangeAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keypad = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? "Add New Expense" : "Edit The Expense",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keypad),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: saveChangeText,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    label: Text("TITLE"),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: saveChangeAmount,
                        keyboardType: TextInputType.number,
                        keyboardAppearance: Brightness.light,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          prefixText: "\u{20B9} ",
                          label: Text("AMOUNT"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            pickedDateFinal == null
                                ? "No Date Selected"
                                : formatted.format(pickedDateFinal!),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          IconButton(
                            onPressed: dateSelected,
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    DropdownButton(
                        value: valueCate,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            valueCate = value;
                          });
                        }),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: saveExpense,
                      child: const Text("Save Change"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
