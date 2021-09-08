import 'package:budgetcents/models/sub_bill.dart';
import 'package:budgetcents/res/constants.dart';

class Bill {
  int budgetId;
  String billName;
  double billAmount;
  List<SubBill> allSubBills;

  Bill({this.budgetId, this.billName, this.billAmount, this.allSubBills});

  Bill.fromMap(Map<dynamic, dynamic> map) {
    this.budgetId = map[Constant.budgetId];
    this.billName = map[Constant.billName];
    this.billAmount = map[Constant.billAmount];
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.budgetId: this.budgetId,
      Constant.billName: this.billName,
      Constant.billAmount: this.billAmount,
    };
  }

  @override
  String toString() {
    return 'Bill{budgetId: $budgetId, billName: $billName, billAmount: $billAmount, allSubBills: $allSubBills}';
  }
}
