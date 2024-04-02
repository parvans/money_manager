import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

ValueNotifier<categoryType> selectedCategoryType =
    ValueNotifier(categoryType.income);
final _nameEditingController = TextEditingController();
Future<void> showCategoryAppPopUp(BuildContext context) async {
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: Text('Add Category'),
        backgroundColor: Colors.white,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Category Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                RadioButton(title: 'Income', type: categoryType.income),
                RadioButton(title: 'Expense', type: categoryType.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () {
                  final _name = _nameEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategoryType.value;
                  final _category = CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    name: _name,
                    type: _type,
                  );
                  CategoryDB().insertCategory(_category);
                  _nameEditingController.clear();
                  selectedCategoryType.value = categoryType.income;
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final categoryType type;
  RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  categoryType? _type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryType,
            builder:
                (BuildContext context, categoryType newCategory, Widget? _) {
              return Radio<categoryType>(
                fillColor: MaterialStateProperty.all(Colors.blue),
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryType.value = value;
                  selectedCategoryType.notifyListeners();
                },
              );
            }),
        Text(title)
      ],
    );
  }
}
