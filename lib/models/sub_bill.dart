import 'package:budgetcents/res/constants.dart';

class SubBill {
  int budgetId;
  String billName;
  String subBillName;
  double subBillAmount;
//  int sectionNumber;

  SubBill(
      {this.budgetId,
      this.billName,
      this.subBillName,
      this.subBillAmount,
//      this.sectionNumber
      });

  SubBill.fromMap(Map<dynamic, dynamic> map) {
    this.budgetId = map[Constant.budgetId];
    this.billName = map[Constant.billName];
    this.subBillName = map[Constant.subBillName];
    this.subBillAmount = map[Constant.subBillAmount];
//    this.sectionNumber = map[Constant.sectionNum];
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.budgetId: this.budgetId,
      Constant.billName: this.billName,
      Constant.subBillName: this.subBillName,
      Constant.subBillAmount: this.subBillAmount,
//      Constant.sectionNum: this.sectionNumber
    };
  }

  @override
  String toString() {
    return 'SubBill{budgetId: $budgetId, billName: $billName, subBillName: $subBillName, subBillAmount: $subBillAmount}';
  }

}
