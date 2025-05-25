import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectedScreen});

  final void Function(String identifier) onSelectedScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(900),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 18),
                Text(
                  'Cooking Up!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          // SideBar ButtonのList ※ListTileは、listの各itemでよく利用される便利なwidget
          ListTile(
            title: Text('Meals'),
            leading: Icon(Icons.restaurant),
            onTap: () {
              onSelectedScreen('meals');
            },
          ),
          ListTile(
            title: Text('Filters'),
            leading: Icon(Icons.settings),
            onTap: () {
              onSelectedScreen('filters');
            },
          ),
        ],
      ),
    );
  }
}
