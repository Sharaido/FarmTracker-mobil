import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/models/IncomeExpense.dart';
import 'package:flutter_app/pages/entity_details.dart';
import 'package:flutter_app/pages/test-pages/farm_properties.dart';
import 'package:provider/provider.dart';

class IncomeExpenseCard extends StatelessWidget {
  final IncomeExpense incomeExpense;
  final Function stateChanged;
  const IncomeExpenseCard({Key key, this.incomeExpense, this.stateChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FlatButton(
        color: !incomeExpense.incomeFlag
            ? Colors.redAccent
            : Colors.greenAccent[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(
            color: !incomeExpense.incomeFlag ? Colors.red : Colors.green,
            width: 4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${incomeExpense.head}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${incomeExpense.cost}',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Text(
                    'TL',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
              Text(
                parseDate(incomeExpense.createdDate),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context2) {
                return AlertDialog(
                  elevation: 10,
                  contentPadding: const EdgeInsets.all(5),
                  content: Container(
                    height: incomeExpense.desc.length > 30 ? 100 : 50,
                    child: Center(
                      child: Text(
                        '${incomeExpense.desc}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  actions: [
                    FlatButton(
                        child: Text(
                          'Sil',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        onPressed: () async {
                          await API.deleteIncomeExpense(incomeExpense.id);
                          Provider.of<PropertyProvider>(context, listen: false)
                              .updateIncomeFuture();
                          Navigator.of(context).pop(true);
                          stateChanged();
                        }),
                    SizedBox(
                      width: 160,
                    ),
                    FlatButton(
                        child: Text(
                          'Kapat',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        }),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                );
              });
        },
      ),
    );
  }
}
