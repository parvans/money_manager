import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/analysis/money_analysis.dart';
import 'package:money_manager/screens/category/category_app_popup.dart';
import 'package:money_manager/screens/category/screen_category.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
    ScreenAnalysis()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:
            const Text('Money Manager', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: MoneyBottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedNotifier,
              builder: (BuildContext context, updatedIndex, Widget? _) {
                return _pages[updatedIndex];
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          if (selectedNotifier.value == 0) {
            print("Add Transaction");
            Navigator.of(context).pushNamed('/add-transaction');
          } else {
            print("Add Category");
            // final _sample = CategoryModel(
            //     name: 'Travel',
            //     type: categoryType.expense,
            //     id: DateTime.now().millisecondsSinceEpoch.toString());
            // CategoryDB().insertCategory(_sample);
            showCategoryAppPopUp(context);
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
