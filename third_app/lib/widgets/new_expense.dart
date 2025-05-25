import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:third_app/models/expense.dart';

final dateFormatter = DateFormat.yMd();

// 外部から値を受け取る(不変の値)だけのクラス
class NewExpense extends StatefulWidget {
  const NewExpense(this.addExpense, {super.key});

  // expensesで管理するexpense情報を追加する関数
  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

// UI表示 + 状態(useState、変化する値に基づいて再描画)を管理するクラス
class _NewExpenseState extends State<NewExpense> {
  // Inputを取得する機能 ※不要になったら必ず削除すること
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  // カレンダー入力
  void _presentDatePicker() async {
    final DateTime now = DateTime.now();
    // Future型: Promiseと同じで、async/awaitが必要
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 3),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // validation submit button
  void _submitExpenseData() {
    // tryParseは、エラーの場合は、nullが代入されるため、nullをifでチェックすればok
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    // validationエラー時の処理
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder:
            (BuildContext buildContext) => AlertDialog(
              title: Text('Invalid input'),
              content: Text(
                'Please make sure a valid title, amount, date and category was entered.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: Text('Okay'),
                ),
              ],
            ),
      );
      return;
    }

    // 成功時は追加
    widget.addExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose(); // 削除
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // キーボードの高さを取得
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (buildContext, constrains) {
        final width = constrains.maxWidth;
        final height = constrains.maxHeight;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 500)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: InputDecoration(label: Text('Title')),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              label: Text('Amount'),
                              prefixText: '\$ ',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: InputDecoration(label: Text('Title')),
                      keyboardType: TextInputType.name,
                    ),
                  if (width >= 500)
                    Row(
                      children: [
                        // expandedを2つ並べることで1:1比率となる
                        DropdownButton(
                          value: _selectedCategory,
                          // Enumを.mapでListに変換
                          items:
                              Category.values
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item, // 表示するTextに応じたenumを取得
                                      child: Text(
                                        item.name.toUpperCase(),
                                      ), // 表示するText
                                    ),
                                  )
                                  .toList(),
                          onChanged: (selectedValue) {
                            setState(() {
                              if (selectedValue == null) {
                                return;
                              }
                              _selectedCategory = selectedValue;
                            });
                          },
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            // Alignmentで行末尾に配置したり、縦方向中央ぞろえに可能
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected'
                                    : dateFormatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        // expandedを2つ並べることで1:1比率となる
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 50,
                            decoration: InputDecoration(
                              label: Text('Amount'),
                              prefixText: '\$ ',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            // Alignmentで行末尾に配置したり、縦方向中央ぞろえに可能
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected'
                                    : dateFormatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  if (width >= 500)
                    Row(
                      children: [
                        Spacer(), // SpaceBetweenの役割
                        ElevatedButton(
                          onPressed: () {
                            // contextを取り除くことで、modalが閉じる
                            // contextはwidgetのツリーノード状態
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: Text('Save Expense'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          // Enumを.mapでListに変換
                          items:
                              Category.values
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item, // 表示するTextに応じたenumを取得
                                      child: Text(
                                        item.name.toUpperCase(),
                                      ), // 表示するText
                                    ),
                                  )
                                  .toList(),
                          onChanged: (selectedValue) {
                            setState(() {
                              if (selectedValue == null) {
                                return;
                              }
                              _selectedCategory = selectedValue;
                            });
                          },
                        ),
                        Spacer(), // SpaceBetweenの役割
                        ElevatedButton(
                          onPressed: () {
                            // contextを取り除くことで、modalが閉じる
                            // contextはwidgetのツリーノード状態
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: Text('Save Expense'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
