import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sixth_app/data/categories.dart';
import 'package:sixth_app/models/category.dart';
// import 'package:sixth_app/models/grocery_item.dart';

// http package
import 'package:http/http.dart' as http;
import 'package:sixth_app/models/grocery_item.dart';

// Widgetが多い場合は、画面用のWidgetをxxxScreenと命名するのが慣習
class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // 対象のForm WidgetにアクセスするにはGlobalKeyを設定する
  final _formKey = GlobalKey<FormState>();

  String _enteredName = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories.entries.first.value;

  // Loading状態 ※asyncValueを使うべき
  var _isSending = false;

  // form submit
  void _saveItem() async {
    // validatorを実行 ※成功時はtrueになる
    if (_formKey.currentState!.validate()) {
      // onSavedを実行
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      // FirebaseにHTTPでデータ保存 ※https://は不要、パスには「.json」をつけること
      final url = Uri.https(
        'flutter-study-1ab8b-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.title,
        }),
      );
      // 自動生成されたidが返却される
      final createdId = json.decode(response.body)['name'];

      if (!mounted) return;

      Navigator.of(context).pop(
        GroceryItem(
          id: createdId,
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new Item')),
      body: Padding(
        padding: EdgeInsets.all(12),
        // Form Widget
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ユーザ入力はForm用のfieldを利用
              TextFormField(
                decoration: InputDecoration(label: Text('Name')),
                maxLength: 50,
                // nullであればvalidation成功、文字列がある場合はvalidation失敗でエラーメッセージとして表示 valueは入力された内容
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return '1～50文字で入力してください';
                  }
                  return null;
                },
                // save処理
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text('Quantity')),
                      initialValue: _enteredQuantity.toString(),
                      keyboardType: TextInputType.number, // 電卓キーボードを表示
                      validator: (value) {
                        // tryParseは失敗時にnullになる
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return '1以上の整数を入力してください';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      // onSavedの代わりにonChangedでok
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isSending
                            ? null
                            : () =>
                                _formKey.currentState!.reset(), // formを初期値にリセット
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child:
                        _isSending
                            ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                            : Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
