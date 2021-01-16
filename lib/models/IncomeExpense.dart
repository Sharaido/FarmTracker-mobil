class IncomeExpense {
  final String id;
  final bool incomeFlag;
  final String createdDate;
  final String head;
  final String desc;
  final double cost;

  IncomeExpense(
      {this.id,
      this.incomeFlag,
      this.createdDate,
      this.head,
      this.desc,
      this.cost});

  factory IncomeExpense.fromJson(Map<String, dynamic> json) {
    return IncomeExpense(
      id: json['ieuid'],
      incomeFlag: json['incomeFlag'],
      createdDate: json['date'],
      head: json['head'],
      desc: json['description'],
      cost: json['cost'],
    );
  }
}
