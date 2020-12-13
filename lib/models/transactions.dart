import 'package:flutter/material.dart';

class Transaction{
  final int id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;

  const Transaction({this.id,this.title,this.amount,this.description
  ,this.date});
}

class Transactions with ChangeNotifier{
  List<Transaction> _transactions = [

  ];
  List<Transaction> get transactions{
    return _transactions;
  }
}