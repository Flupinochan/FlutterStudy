import 'package:flutter/material.dart';
import 'package:third_app/widgets/chart/chart.dart';
import 'package:third_app/widgets/expenses_list/expenses_list.dart';
import 'package:third_app/models/expense.dart';
import 'package:third_app/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  // Global Data
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  // +ボタン
  void _openAddExpenseOverlay() {
    // show...メソッドでDialogの表示など様々な機能がある
    showModalBottomSheet(
      useSafeArea: true, // モーダルなどを開く際に、画面上部のカメラの余白を自動考慮する
      isScrollControlled: true, // 画面全体をオーバーレイ
      context: context,
      builder: (BuildContext buildContext) {
        return NewExpense(_addExpense);
      },
    );
  }

  // +からSubmit時にExpenseを追加
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  // Listから削除する機能
  void _removeExpense(Expense expense) {
    final index = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    // 既存の通知メッセージを削除
    ScaffoldMessenger.of(context).clearSnackBars();
    // 削除後に、操作を戻すための一時的な通知メッセージ(snackbar)を表示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense deleted.'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // HTMLの@mediaと同じ、画面を横にすれば横のサイズが取得される
    // 画面を横にすると再レンダリングされる
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(_registeredExpenses, _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false, // 一部のデバイスでは、タイトルが中央に表示される
        title: Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:
          // 768px未満以上でUIを分岐
          width < 768
              ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  // Expandedは残りのスペース全てを利用する設定
                  // 子WidgetがRow, Column, ListViewなど動的の場合に利用
                  Expanded(child: mainContent),
                ],
              )
              // Rowは横方向に対して制限がない、スクロール可能な状態になる
              // ※逆にColumnは縦方向に対して制限がなく、スクロール可能(ListView)な状態になる
              // スクロールは縦方向のみ許可すべき
              // そのため、全てExpandedでwrapして、比率で横幅を固定すべき
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(child: mainContent),
                ],
              ),
    );
  }
}
