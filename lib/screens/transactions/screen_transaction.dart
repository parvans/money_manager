import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/traansaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreashUia();
    CategoryDB.instance.refreashUi();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListListener,
        builder: (BuildContext cxt, List<TransactionModel> newList, Widget? _) {
          return (TransactionDB.instance.transactionListListener.value.length !=
                  0
              ? ListView.separated(
                  padding: const EdgeInsets.all(5),
                  itemBuilder: (context, index) {
                    final _tran = newList[index];
                    return Slidable(
                      key: Key(_tran.id!),
                      startActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (cxt) {
                            TransactionDB.instance.deleteTransaction(_tran.id!);
                          },
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          // label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (cxt) {
                            HapticFeedback.vibrate();
                            print('cancel');
                          },
                          backgroundColor: Colors.green,
                          icon: Icons.cancel,
                          // label: 'Delete',
                        ),
                      ]),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              parseDate(_tran.date),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            radius: 50,
                          ),
                          title: Text(_tran.purpose.length > 20
                              ? _tran.purpose.substring(0, 12) + '...'
                              : _tran.purpose),
                          subtitle: Text(_tran.category.name.length > 20
                              ? _tran.category.name.substring(0, 12) + '...'
                              : _tran.category.name),
                          trailing: (_tran.type == categoryType.income)
                              ? Text(
                                  '+ ${_tran.amount}',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                )
                              : Text(
                                  '- ${_tran.amount}',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: newList.length,
                )
              : Center(
                  child: Text('No Transaction Yet',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey[600]))));
        });
  }

  String parseDate(DateTime date) {
    var month = DateFormat.MMM().format(date);
    return '${date.day}\n${month}';
  }
}
