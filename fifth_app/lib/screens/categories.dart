import 'package:fifth_app/models/category.dart';
import 'package:fifth_app/models/meal.dart';
import 'package:fifth_app/screens/meals.dart';
import 'package:fifth_app/widgets/category_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:fifth_app/data/dummy_data.dart';

// アニメーションをするには、StatefulWidgetにする必要がある
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen(this.availableMeals, {super.key});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// 自分で定義するExplicit Animation
// シングルアニメーション: SingleTickerProviderStateMixin
// マルチアニメーション: TickerProviderStateMixin
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // 0.3秒かけて0から1の間で変化するアニメーションを定義
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    // アニメーションを実行
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    // アニメーションを削除
    _animationController.dispose();
  }

  // Navigator push でWidgetを遷移したら、自動的にappBarに←Buttonが追加される
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals =
        widget.availableMeals
            .where((meal) => meal.categories.contains(category.id))
            .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (ctx) => MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // builderにアニメーション、childに子Widgetを指定
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(category, () {
              _selectCategory(context, category);
            }),
        ],
      ),
      // top paddingを100から0にするアニメーション
      // builder:
      //     (context, child) => Padding(
      //       padding: EdgeInsets.only(
      //         top: 100 - _animationController.value * 100,
      //       ),
      //       child: child,
      //     ),

      // スライドする組み込みアニメーション
      builder:
          (context, child) => SlideTransition(
            // Offset(X軸, Y軸)
            position: Tween(begin: Offset(0, 0.3), end: Offset(0, 0)).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut, // easeInOutを適用
              ),
            ),
            child: child,
          ),
    );
  }
}
