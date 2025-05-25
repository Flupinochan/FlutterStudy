import 'package:flutter/material.dart';
import 'package:third_app/models/expense.dart';

class ExpensesItem extends StatelessWidget {
  const ExpensesItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Cardにはpadding設定がないため、Padding Widgetを使う
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // 数が決まっている場合はListViewではなくColumnでよい
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 4),
            // toStringAsFixedで、小数点2桁固定
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                Spacer(), // Text(左), Spacer, Row(右)
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    SizedBox(width: 8),
                    Text(expense.getFormattedDate()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
