import 'package:flutter/material.dart';

class Transaction{
  final int id;
  final String title;
  final String description;
  final double amount;
  final int date;
  final String isexpense;

  

  const Transaction({this.id,
  @required this.title,
  @required this.amount,
  @required this.description,
  @required this.date,
  @required this.isexpense});

  
}

class Transactions with ChangeNotifier{
  List<Transaction> _transactions = [

  ];
  List<Transaction> get transactions{
    return _transactions;
  }
}