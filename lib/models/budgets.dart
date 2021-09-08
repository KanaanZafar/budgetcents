import 'package:budgetcents/models/bill.dart';
import 'package:budgetcents/models/income.dart';
import 'package:budgetcents/res/constants.dart';

class Budget {
  int budgetId;

//  String currentUserUid;
//  double Totalincome;
//  double budgeted;
  List<Income> allIncomes;

  List<Bill> allBills;

  Budget(
      {this.budgetId,
//      this.currentUserUid,
//      this.income,
//      this.budgeted,
      this.allIncomes,
      this.allBills});

  Budget.fromMap(Map<dynamic, dynamic> map) {
    this.budgetId = map[Constant.budgetId];
//    this.currentUserUid = map[Constant.currentUserUid];
//    this.income = map[Constant.income];
//    this.budgeted = map[Constant.budgeted];
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.budgetId: this.budgetId,
//      Constant.currentUserUid: this.currentUserUid,
//      Constant.income: this.income,
//      Constant.budgeted: this.budgeted
    };
  }

  @override
  String toString() {
    return 'Budget{budgetId: $budgetId, allBills: $allBills}';
  }
}
