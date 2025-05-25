import 'package:fifth_app/models/category.dart';
import 'package:flutter/material.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem(this.category, this.onSelectCategory, {super.key});

  final Category category;
  final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context) {
    // InkWellは子WidgetをButton(タップ)可能にする
    return InkWell(
      onTap: onSelectCategory,
      // tapした際のエフェクト設定
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      // Containerは汎用Widget、背景、サイズ、余白などを設定
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withAlpha(500),
              category.color.withAlpha(900),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
