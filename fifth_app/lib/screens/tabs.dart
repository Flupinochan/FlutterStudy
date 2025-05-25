import 'package:fifth_app/screens/categories.dart';
import 'package:fifth_app/screens/filters.dart';
import 'package:fifth_app/screens/meals.dart';
import 'package:fifth_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fifth_app/providers/favorite_provider.dart';
import 'package:fifth_app/providers/filters_provider.dart';

const kInitialFilters = {
  Filters.glutenFree: false,
  Filters.lactoseFree: false,
  Filters.vegetarian: false,
  Filters.vegan: false,
};

// ConsumerStatefulWidgetは、river podの機能(provider)が利用可能になるWidget
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  // ConsumerState
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

// ConsumerState
class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // 遷移先でpopする際の引数をresultで受け取る ※pushのみでpushReplacementでは受け取れない
      await Navigator.of(context).push<Map<Filters, bool>>(
        MaterialPageRoute(builder: (ctx) => FiltersScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider使用例 watchでProviderの値を取得、状態が変わるたびに再ビルドする (GraphQLのSubscriptionと同じ)
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(availableMeals);
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(meals: favoriteMeals);
      activePageTitle = 'Favorites';
    }

    // PopScopeで戻るボタンを押した際の動作を変更可能
    // アプリ終了確認ボタンを表示する
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text('終了確認', style: TextStyle(color: Colors.white)),
                content: Text(
                  'アプリを終了してもよろしいですか？',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    child: Text('キャンセル', style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  TextButton(
                    child: Text('終了', style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
        );

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(activePageTitle)),
        body: activePage,
        drawer: MainDrawer(onSelectedScreen: _setScreen),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal),
              label: 'Categories',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          ],
        ),
      ),
    );
  }
}
