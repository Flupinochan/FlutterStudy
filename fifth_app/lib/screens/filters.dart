// import 'package:fifth_app/screens/tabs.dart';
// import 'package:fifth_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fifth_app/providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  // ProviderでState管理すれば、基本的にStatefulWidgetは不要 ※再ビルドは、StatelessWidgetのref.watch()で可能
  // build外(initState)で、1度だけ読み込まれる場合は、ref.read()
  // build内(onPressed)で、Buttonで何度も実行される可能性がある場合は、ref.watch()

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    // Scaffoldは、各画面共通の構造(スケルトン)の1つであり、一択
    // appBarやdrawerなどが付属していて便利
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Filters')),
        // drawerを配置すると戻るbuttonと置き換わる
        // drawer: MainDrawer(
        //   onSelectedScreen: (identifier) {
        //     // popに引数を渡すと、このwidget呼び出し元に値を渡せる
        //     // ※WPFのDialogResultと同じ
        //     Navigator.of(context).pop({
        //       Filters.glutenFree: _glutennFreeFilterSet,
        //       Filters.lactoseFree: _lactoseFreeFilterSet,
        //       Filters.vegetarian: _vegetarianFilterSet,
        //       Filters.vegan: _veganFilterSet,
        //     });
        //     if (identifier == 'meals') {
        //       // pushとpushReplacementの違いとしては、戻ることが可能かどうか
        //       // Sidebar(drawer)には戻らなくてよい
        //       Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (ctx) => TabsScreen()),
        //       );
        //     }
        //   },
        // ),
        body: Column(
          children: [
            // on/off切り替え機能(toggle button)付きのListItem
            SwitchListTile(
              value: activeFilters[Filters.glutenFree]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filters.glutenFree, isChecked);
              },
              title: Text('Gluten-free'),
              subtitle: Text('Only include gluten-free meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: activeFilters[Filters.lactoseFree]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filters.lactoseFree, isChecked);
              },
              title: Text('Lactose-free'),
              subtitle: Text('Only include lactose-free meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: activeFilters[Filters.vegetarian]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filters.vegetarian, isChecked);
              },
              title: Text('Vegetarian'),
              subtitle: Text('Only include vegetarian meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: activeFilters[Filters.vegan]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filters.vegan, isChecked);
              },
              title: Text('Vegan'),
              subtitle: Text('Only include vegan meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
