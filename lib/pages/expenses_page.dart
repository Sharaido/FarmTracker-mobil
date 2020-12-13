import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customs/new_transaction.dart';
import '../customs/header.dart';
import '../customs/transaction_card.dart';
import '../models/transactions.dart';

class ExpensesPage extends StatefulWidget {
  
   final String title;

   const ExpensesPage({Key key,@required this.title}) : super(key: key);

   static const Map<int,Color> colorMap={
    50:Color.fromRGBO(42, 54, 59, 0.1),
    100:Color.fromRGBO(42, 54, 59, 0.2),
    200:Color.fromRGBO(42, 54, 59, 0.3),
    300:Color.fromRGBO(42, 54, 59, 0.4),
    400:Color.fromRGBO(42, 54, 59, 0.5),
    500:Color.fromRGBO(42, 54, 59, 0.6),
    600:Color.fromRGBO(42, 54, 59, 0.7),
    700:Color.fromRGBO(42, 54, 59, 0.8),
    800:Color.fromRGBO(42, 54, 59, 0.9),
    900:Color.fromRGBO(42, 54, 59, 1.0),
  };
  
  static const MaterialColor _2A3638= MaterialColor(0xFF2A3638, colorMap);
  
  /*Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => Transactions(),
      child: MaterialApp(
        title: 'Personal Finance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: _2A3638,
          fontFamily: 'Quicksand',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ),
      );
  }*/


  @override
  _ExpensesState createState() => _ExpensesState();
}



class _ExpensesState extends State<ExpensesPage> {
  double _height = .55;
  double _opacity = .9;

  void _addTransaction(){
    setState(() {
      _height = .08; 
      _opacity = 1;
    });
  }

  void _done(){
    setState(() {
      _height = .55; 
      _opacity = 9;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: new IconThemeData(color: Colors.green),
        title: Text(
          widget.title.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
          children:<Widget>[
            Column(
              children: <Widget>[
                Header(_addTransaction),
                NewTransaction(_opacity, _done),
                ],
          ),
          TransactionCard(_height),
        ],
      ),
    );
  }
}