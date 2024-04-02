import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/traansaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/screens/category/category_app_popup.dart';

class ScreenAddTransaction extends StatefulWidget {
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDates;
  categoryType? _selectedCategoryType;
  CategoryModel? _selectedCategory;
  String? _selectedCategoryId;

  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = categoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: _purposeController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                labelText: 'Purpose',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0))),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0))),
          ),
          const SizedBox(
            height: 10,
          ),

          TextButton.icon(
              style: ButtonStyle(
                  iconColor: MaterialStateProperty.all(Colors.blue)),

              //date
              onPressed: () async {
                // print('Select Date');

                final _selectedDateTemp = await showDatePicker(
                    // builder: (context, child) {
                    //   return Theme(
                    //     data: ThemeData.light().copyWith(
                    //       colorScheme: ColorScheme.light(
                    //         primary: Colors.white,
                    //         onPrimary: Colors.blue,
                    //         onSurface: Colors.blue,
                    //       ),
                    //     ),
                    //     child: child!,
                    //   );
                    // },
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now());
                if (_selectedDateTemp == null) {
                  return;
                } else {
                  // print(_selectedDateTemp.toString());

                  setState(() {
                    _selectedDates = _selectedDateTemp;
                  });
                }
              },
              icon: Icon(Icons.calendar_today),
              label: Text(
                _selectedDates == null
                    ? 'Select Date'
                    : _selectedDates.toString(),
                style: TextStyle(color: Colors.blue),
              )),

          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio(
                      fillColor: MaterialStateProperty.all(Colors.blue),
                      value: categoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryType = categoryType.income;
                          _selectedCategoryId = null;
                        });
                      }),
                  Text(
                    'Income',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                      fillColor: MaterialStateProperty.all(Colors.blue),
                      value: categoryType.expense,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryType = categoryType.expense;
                          _selectedCategoryId = null;
                        });
                      }),
                  Text(
                    'Expense',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          DropdownButton(
            // items: const [
            //   DropdownMenuItem(
            //     child: Text('Category 1'),
            //     value: 'Category 1',
            //   ),
            //   DropdownMenuItem(
            //     child: Text('Category 2'),
            //     value: 'Category 2',
            //   ),
            //   DropdownMenuItem(
            //     child: Text('Category 3'),
            //     value: 'Category 3',
            //   ),
            // ],
            hint: const Text('Select Category'),
            value: _selectedCategoryId,
            items: (_selectedCategoryType == categoryType.income
                    ? CategoryDB.instance.incomeCategoryListListener.value
                    : CategoryDB.instance.expenseCategoryListListener.value)
                .map((category) {
              return DropdownMenuItem(
                onTap: () {
                  print(category.toString());
                  _selectedCategory = category;
                },
                child: Text(category.name),
                value: category.id,
              );
            }).toList(),
            onChanged: (value) {
              // print(value);
              setState(() {
                _selectedCategoryId = value;
              });
            },
          ),
          //submit
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () {
                addTransaction(context);
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              label: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    )));
  }

  Future<void> addTransaction(BuildContext context) async {
    final _purpose = _purposeController.text;

    final _amount = _amountController.text;

    if (_purpose.isEmpty) {
      return;
    }
    if (_amount.isEmpty) {
      return;
    }
    // if (_selectedCategoryId == null) {
    //   return;
    // }
    if (_selectedDates == null) {
      return;
    }
    if (_selectedCategory == null) {
      return;
    }

    final _parseAmount = double.tryParse(_amount);
    if (_parseAmount == null) {
      return;
    }

    final _model = TransactionModel(
        purpose: _purpose,
        amount: _parseAmount,
        date: _selectedDates!,
        type: _selectedCategoryType!,
        category: _selectedCategory!);

    TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    print("Transaction Added Successfully!");
  }
}
