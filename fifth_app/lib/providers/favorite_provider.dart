import 'package:fifth_app/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// お気に入りのMealを格納する状態、初期値は[]

// T型に管理する値の型を指定
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  // super()に初期値を指定
  FavoriteMealsNotifier() : super([]);

  // お気に入りに追加/削除する関数
  bool toggleMealFavoriteStatus(Meal meal) {
    // 関数でstateを操作することでList<Meal>を操作可能
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      // state.remove(meal.id) のような操作は不可能。再代入する必要がある
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

// 変化する値を提供する場合は、ProviderではなくStateNotifierProvider()
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>(
      (ref) => FavoriteMealsNotifier(),
    );
