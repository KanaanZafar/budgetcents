import 'package:budgetcents/res/constants.dart';

class Income {
  int budgetId;
  String incomeSourceName;
  int incomeDate;
  double incomeAmount;

  Income(
      {this.budgetId,
      this.incomeSourceName,
      this.incomeDate,
      this.incomeAmount});

  Income.fromMap(Map<dynamic, dynamic> map) {
    this.budgetId = map[Constant.budgetId];
    this.incomeSourceName = map[Constant.incomeSourceName];
    this.incomeDate = map[Constant.incomeDate];
    this.incomeAmount = map[Constant.incomeAmount];
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.budgetId: this.budgetId,
      Constant.incomeSourceName: this.incomeSourceName,
      Constant.incomeDate: this.incomeDate,
      Constant.incomeAmount: this.incomeAmount
    };
  }

  @override
  String toString() {
    return '--Income{budgetId: $budgetId, incomeSourceName: $incomeSourceName, incomeDate: $incomeDate, incomeAmount: $incomeAmount}';
  }
}
