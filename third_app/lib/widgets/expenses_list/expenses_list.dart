import 'package:flutter/material.dart';
import 'package:third_app/models/expense.dart';
import 'package:third_app/widgets/expenses_list/expenses_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
    this.registeredExpenses,
    this.onRemoveExpense, {
    super.key,
  });

  final List<Expense> registeredExpenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // 追加や削除されるListで未知の長さの場合は、ColumnではなくListViewを利用する
    // builderを利用すると大量のListの場合に、効率的に一部だけ表示する
    return ListView.builder(
      itemCount: registeredExpenses.length,
      // Dismissibleは、ListのItemをスワイプすることで、Listから削除可能にする機能
      itemBuilder:
          (buildContext, index) => Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error.withAlpha(100),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
            ),
            key: ValueKey(registeredExpenses[index]),
            child: ExpensesItem(registeredExpenses[index]),
            // onDismissedは、スワイプした時に呼ばれる関数
            // directionでスワイプの方向に応じた処理も可能
            onDismissed: (direction) {
              onRemoveExpense(registeredExpenses[index]);
            },
          ),
    );
  }
}
