import 'package:flutter/material.dart';

import '../models/meal.dart';
import 'categories.dart';
import 'meals.dart';

// setState() 사용이 필요함으로 StatefulWidget을 상속받아야 한다.
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  // 좋아하는 음식의 상태 관리를 위해 최상단에 data list 선언
  final List<Meal> _favoriteMeals = [];

  // app 전반의 상태관리를 위해 관리대상 상태와 함께 복수 계층으로 전달될 함수 정의
  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    void showInfoMessage(String message) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      showInfoMessage('This meal has been removed from your favorites.');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        showInfoMessage('This meal has been marked as your favorites.');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
    );
    var activePageTitle = 'Categories';

    // 좋아하는 음식에 대한 상태를 보여주기 위해 하위에서 발생하는 상태변화에 대해 전달받을 필요가 있음.
    if (_selectedPageIndex == 1) {
      // Scaffold 를 사용하지 않으므로 title 미사용
      activePage = MealsScreen(
        onToggleFavorite: _toggleMealFavoriteStatus,
        meals: _favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage, // tab 선택에 따라 activePage 변경
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
