import 'package:expense_record/provider/addedexpense.dart';
import 'package:flutter/material.dart';
import 'package:expense_record/models/expense_dits.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Lists extends ConsumerStatefulWidget {
  const Lists(
      {super.key, required this.expenseList, required this.onDismissed});
  final void Function(ExpenseDets del) onDismissed;
  final List<ExpenseDets> expenseList;

  @override
  ConsumerState<Lists> createState() => _ListsState();
}

class _ListsState extends ConsumerState<Lists> {
  late Future<void> loadExpenseList;
  @override
  void initState() {
    super.initState();
    loadExpenseList = ref.read(addExpenseProvider.notifier).loadExpense();
  }

  @override
  Widget build(context) {
    return ListView.builder(
        itemCount: widget.expenseList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(widget.expenseList[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.8),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                vertical: Theme.of(context).cardTheme.margin!.vertical,
              ),
            ),
            onDismissed: (direction) {
              widget.onDismissed(
                widget.expenseList[index],
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.expenseList[index].title),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\u{20B9}${widget.expenseList[index].amount.toStringAsFixed(2)}',
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              categoryItem[widget.expenseList[index].category],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.expenseList[index].formattedDate
                                  .toString(),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
