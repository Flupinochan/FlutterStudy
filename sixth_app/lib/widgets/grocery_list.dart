import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sixth_app/data/categories.dart';
import 'package:sixth_app/models/grocery_item.dart';
import 'package:sixth_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  // 画面読み込み時の処理 (GETリクエスト)
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https(
      'flutter-study-1ab8b-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    try {
      // FirebaseにGETリクエスト
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        _error = 'Failed to fetch data. Please try again later.';
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category =
            categories.entries
                .firstWhere(
                  (categoryItem) =>
                      categoryItem.value.title == item.value['category'],
                )
                .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      _error = 'Something went wrong! Please try again later.';
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  // 追加
  void _addItem(BuildContext context) async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  // 削除
  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
      'flutter-study-1ab8b-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );

    final response = await http.delete(url);
    // 削除失敗時は戻す ※エラーメッセージなども表示するとよい
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    // Loading Spinnerの表示
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    // 初期状態、データが空の場合
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder:
            (ctx, index) => Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                _removeItem(_groceryItems[index]);
              },
              child: ListTile(
                title: Text(_groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            ),
      );
    }

    // エラー時のメッセージ
    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: () => _addItem(context), icon: Icon(Icons.add)),
        ],
      ),
      // asyncなどの非同期処理が完了したらUI更新するWidget
      body: content,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Your Groceries'),
  //       actions: [
  //         IconButton(onPressed: () => _addItem(context), icon: Icon(Icons.add)),
  //       ],
  //     ),
  //     // asyncなどの非同期処理が完了したらUI更新するWidget
  //     // ※ただし、1度だけしか再レンダリングしなく、setStateでUI更新できないため注意
  //     body: FutureBuilder(
  //       future: _loadedItems,
  //       builder: (context, snapshot) {
  //         // errorがthrowされた場合
  //         if (snapshot.hasError) {
  //           return Center(child: Text(snapshot.error.toString()));
  //         }

  //         // データが空の場合
  //         if (snapshot.data == null || snapshot.data!.isEmpty) {
  //           return const Center(child: Text('No items added yet.'));
  //         }

  //         // Loading Spinnerの表示
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         return ListView.builder(
  //           itemCount: snapshot.data!.length,
  //           // itemCount: _groceryItems.length,
  //           itemBuilder:
  //               (ctx, index) => Dismissible(
  //                 key: ValueKey(snapshot.data![index].id),
  //                 onDismissed: (direction) {
  //                   _removeItem(snapshot.data![index]);
  //                 },
  //                 child: ListTile(
  //                   title: Text(snapshot.data![index].name),
  //                   leading: Container(
  //                     width: 24,
  //                     height: 24,
  //                     color: snapshot.data![index].category.color,
  //                   ),
  //                   trailing: Text(snapshot.data![index].quantity.toString()),
  //                 ),
  //               ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
