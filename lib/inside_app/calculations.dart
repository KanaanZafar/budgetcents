import 'package:budgetcents/database_helper/database_helper.dart';
import 'package:budgetcents/inside_app/income_bakchodi.dart';
import 'package:budgetcents/inside_app/results.dart';
import 'package:budgetcents/models/bill.dart';
import 'package:budgetcents/models/budgets.dart';
import 'package:budgetcents/models/income.dart';
import 'package:budgetcents/models/sub_bill.dart';
import 'package:budgetcents/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

import 'package:string_validator/string_validator.dart';

class Calculations extends StatefulWidget {
  int budgetTypeNum;
  int budgetGoalNum;
  List<Budget> budgetsList;

  Calculations(
    this.budgetTypeNum,
    this.budgetGoalNum,
    this.budgetsList,
  );

  @override
  _CalculationsState createState() => _CalculationsState(
        budgetTypeNum,
        budgetGoalNum,
        budgetsList,
      );
}

class _CalculationsState extends State<Calculations> {
  int budgetTypeNum;
  int budgetGoalNum;
  List<Budget> budgetsList;
  List<Bill> billsList;
  List<SubBill> subBillsList;
  List<Income> incomesList;
  List<String> secRowStrings;

//  bool subBillsAddedOnce = false;
  List<Widget> subBillsWidgetsList = List<Widget>();
  List<List<Bill>> billsSectionList =
      List<List<Bill>>.generate(4, (i) => List<Bill>());

  List<Widget> subBillButtons = List<Widget>();
  String calculatorAsset = 'assets/calculator.png';
  String calenderAsset = 'assets/calender.png';

//  List<String> payCheques = [
//    'PAY CHEQUE 1',
//    'PAY CHEQUE 2',
//    'PAY CHEQUE 3',
//    'PAY CHEQUE 4'
//  ];

  _CalculationsState(
    this.budgetTypeNum,
    this.budgetGoalNum,
    this.budgetsList,
  );

  String month = '';
  String year = '';
  double leftInBudgetVal = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String whichBill = '';

//  TextEditingController incomeController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  int currentBudget;
  TextStyle smallTextStyle;
  TextStyle mediumTextStyle;
  TextStyle largeTextStyle;
  TextStyle littleMediumTextStyle;
  List<String> billsNames;
  bool dropdownListOpened = false;
  int billListPointer = -1;
  BoxDecoration greyBoxDecoration;
  BoxDecoration greenBoxDecoration;
  BoxDecoration greenBorderBoxDecoration;
  BoxDecoration greyBoxWithoutBorder;
  List<TextEditingController> billNameTEControllers =
      List<TextEditingController>();
  List<TextEditingController> subBillNameTEControllers =
      List<TextEditingController>();
  List<TextEditingController> subBillValTEControllers =
      List<TextEditingController>();
  List<TextEditingController> billValTEControllers =
      List<TextEditingController>();
  bool saving;
  bool dataLoading;
  double totalIncome = 0.0;
  double budgeted = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialBakchodi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constant.backgroundColor),
      appBar: PreferredSize(
          child: reqAppBar(), preferredSize: Size.fromHeight(100.0)),
      body: Center(
          child: dataLoading != true
              ? Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        billListPointer == -1 ? dateTxt() : Container(),
                        billListPointer == -1
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 100,
                              )
                            : Container(),
                        reqBox(),
                      ],
                    ),
                  ),
                )
              : CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(Constant.whiteColor)),
                )),
    );
  }

  initialBakchodi() async {
    setState(() {
      dataLoading = true;
    });
    greyBoxDecoration = _boxDecoration(true, false, true);
    greenBoxDecoration = _boxDecoration(false, false, false);
    greenBorderBoxDecoration = _boxDecoration(true, true, false);
    greyBoxWithoutBorder = _boxDecoration(true, false, false);
    billsNames = [
      Constant.houseHold.toUpperCase(),
      Constant.utilities.toUpperCase(),
      Constant.transporation.toUpperCase(),
      Constant.personal.toUpperCase(),
      Constant.budgetGoals[0].toUpperCase(),
      Constant.budgetGoals[1].toUpperCase(),
      'SAVE MONEY/PAY DEBT'
//      budgetGoalNum == 2
//          ? 'SAVE MONEY/PAY DEBT'
//          : Constant.budgetGoals[budgetGoalNum].toUpperCase()
    ];

    if (budgetsList.length > 0 &&
        DateTime.now().month ==
            DateTime.fromMillisecondsSinceEpoch(
                    budgetsList[budgetsList.length - 1].budgetId)
                .month &&
        DateTime.now().year ==
            DateTime.fromMillisecondsSinceEpoch(
                    budgetsList[budgetsList.length - 1].budgetId)
                .year) {
      billsList = List<Bill>();

      print(
          '==== ${budgetsList[budgetsList.length - 1].allBills.length} and ${budgetGoalNum}');

      for (int i = 0; i < 5; i++) {
        billsList.add(budgetsList[budgetsList.length - 1]
            .allBills[i < 4 ? i : i + budgetGoalNum]);

        budgeted = budgeted + billsList[i].billAmount;
      }
      incomesList = budgetsList[budgetsList.length - 1].allIncomes;
      for (int i = 0; i < incomesList.length; i++) {
        totalIncome = totalIncome + incomesList[i].incomeAmount;
      }
      leftInBudgetVal = totalIncome - budgeted;
    } else {
      billsList = List<Bill>();
      incomesList = List<Income>();
      Budget budget = Budget();
      budget.budgetId = DateTime.now().millisecondsSinceEpoch;
      budgeted = 0;
      budget.allIncomes = List<Income>();
      budgetsList.add(budget);
      await databaseHelper.insertBudget(budget);
    }
    currentBudget = budgetsList.length - 1;
    smallTextStyle = _textStyle(false, 12.5);
    mediumTextStyle = _textStyle(false, 20);
    littleMediumTextStyle = _textStyle(false, 15);
    largeTextStyle = _textStyle(true, 30);
    secRowStrings = [
      Constant.income.toUpperCase(),
      "BUDGETED",
      Constant.leftInBudget.toUpperCase()
    ];

    if (billsList.length == 0) {
      List<Bill> tmpBillsList = List<Bill>();
      for (int i = 0; i < billsNames.length; i++) {
        Bill bill = Bill();
        bill.budgetId = budgetsList[currentBudget].budgetId;
        bill.billName = billsNames[i];
        bill.billAmount = 0;
        bill.allSubBills = [];
        if (i == 0) {
          for (int j = 0; j < Constant.subHouseHolds.length; j++) {
            SubBill sub = SubBill();

            sub.billName = bill.billName;
            sub.budgetId = bill.budgetId;
            sub.subBillName = Constant.subHouseHolds[j];
            sub.subBillAmount = 0;
            bill.allSubBills.add(sub);
            await databaseHelper.insertSubBill(sub);
          }
        } else if (i == 1) {
          for (int k = 0; k < Constant.subUtilities.length; k++) {
            SubBill sub = SubBill();

            sub.billName = bill.billName;
            sub.budgetId = bill.budgetId;
            sub.subBillName = Constant.subUtilities[k];
            sub.subBillAmount = 0;
            bill.allSubBills.add(sub);
            await databaseHelper.insertSubBill(sub);
          }
        } else if (i == 2) {
          for (int l = 0; l < Constant.subTransporations.length; l++) {
            SubBill sub = SubBill();

            sub.billName = bill.billName;
            sub.budgetId = bill.budgetId;
            sub.subBillName = Constant.subTransporations[l];
            sub.subBillAmount = 0;
            bill.allSubBills.add(sub);
            await databaseHelper.insertSubBill(sub);
          }
        } else if (i == 4) {
          SubBill sub = SubBill();

          sub.billName = bill.billName;
          sub.budgetId = bill.budgetId;
          sub.subBillAmount = 0;
          sub.subBillName = Constant.akhriChuss[0];
          bill.allSubBills.add(sub);
          await databaseHelper.insertSubBill(sub);
          /*   if (budgetGoalNum < 2) {
            sub.subBillName = Constant.akhriChuss[budgetGoalNum];
            bill.allSubBills.add(sub);
            databaseHelper.insertSubBill(sub);
          } else {
            for (int m = 0; m < Constant.akhriChuss.length; m++) {
              sub.subBillName = Constant.akhriChuss[m];
              bill.allSubBills.add(sub);
              databaseHelper.insertSubBill(sub);
            }
          } */

        } else if (i == 5) {
          SubBill sub = SubBill();

          sub.billName = bill.billName;
          sub.budgetId = bill.budgetId;
          sub.subBillAmount = 0;
          sub.subBillName = Constant.akhriChuss[1];
          bill.allSubBills.add(sub);
          await databaseHelper.insertSubBill(sub);
        } else if (i == 6) {
          for (int z = 0; z < Constant.akhriChuss.length; z++) {
            SubBill sub = SubBill();

            sub.billName = bill.billName;
            sub.budgetId = bill.budgetId;
            sub.subBillName = Constant.akhriChuss[z];
            sub.subBillAmount = 0;
            bill.allSubBills.add(sub);
            await databaseHelper.insertSubBill(sub);
//
//            List<SubBill> tmp = List<SubBill>();
//            tmp =
//                await databaseHelper.subBills(budgetsList[currentBudget], bill);
          }
        }
        if (i < 4) {
          billsList.add(bill);
        } else if (i == 4) {
          if (budgetGoalNum == 0) {
            billsList.add(bill);
          }
        } else if (i == 5) {
          if (budgetGoalNum == 1) {
            billsList.add(bill);
          }
        } else if (i == 6) {
          if (budgetGoalNum == 2) {
            billsList.add(bill);
          }
        }
        tmpBillsList.add(bill);
        await databaseHelper.insertBill(bill);
//        subbillsMapsList.add({bill: []});
      }

//      budgetsList[currentBudget].allBills = billsList;
      budgetsList[currentBudget].allBills = tmpBillsList;
//   if(budgetGoalNum == 2){
//      budgetsList[currentBudget]
//          .allBills[6]
//          .allSubBills
//          .add(budgetsList[currentBudget].allBills[4].allSubBills[0]);
//      budgetsList[currentBudget]
//   }

    }

    setState(() {
      dataLoading = false;
    });
  }

  Widget dateTxt() {
    int monthInt;
    if (budgetsList.length == 0) {
      monthInt = DateTime.now().month;
      year = DateTime.now().year.toString();
    } else {
      monthInt = DateTime.fromMillisecondsSinceEpoch(
              budgetsList[currentBudget].budgetId)
          .month;
      year = DateTime.fromMillisecondsSinceEpoch(
              budgetsList[currentBudget].budgetId)
          .year
          .toString();
    }

    if (monthInt == 1) {
      month = 'JANUARY';
    } else if (monthInt == 2) {
      month = 'FEBRURAY';
    } else if (monthInt == 3) {
      month = 'MARCH';
    } else if (monthInt == 4) {
      month = 'APRIL';
    } else if (monthInt == 5) {
      month = "MAY";
    } else if (monthInt == 6) {
      month = 'JUNE';
    } else if (monthInt == 7) {
      month = 'JULY';
    } else if (monthInt == 8) {
      month = 'AUGUST';
    } else if (monthInt == 9) {
      month = 'SEPTEMBER';
    } else if (monthInt == 10) {
      month = 'OCTOBER';
    } else if (monthInt == 11) {
      month = 'NOVEMBER';
    } else {
      month = 'DECEMBER';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        currentBudget > 0
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(Constant.whiteColor),
                ),
                onPressed: () {
                  currentBudget--;

                  sameBakchodi();
                })
            : Container(),
        Text(
          '${month} ${year}',
          style: largeTextStyle,
          textScaleFactor: 1.25,
        ),
        currentBudget < budgetsList.length - 1
            ? IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(Constant.whiteColor),
                ),
                onPressed: () {
//                  setState(() {
                  currentBudget++;
//                  });
                  sameBakchodi();
                })
            : Container(),
      ],
    );
  }

  sameBakchodi() async {
    setState(() {
      dataLoading = true;
    });
    List<Bill> tmp =
        await databaseHelper.relatedBills(budgetsList[currentBudget]);
//    print(
//        '&&&&& ${tmp.length}');

    budgeted = 0.0;
    totalIncome = 0.0;
    incomesList =
        await databaseHelper.relatedIncomes(budgetsList[currentBudget]);
    for (int i = 0; i < incomesList.length; i++) {
      totalIncome = totalIncome + incomesList[i].incomeAmount;
    }
    budgetsList[currentBudget].allIncomes = incomesList;

    for (int i = 0; i < tmp.length; i++) {
      tmp[i].allSubBills =
          await databaseHelper.subBills(budgetsList[currentBudget], tmp[i]);
      if (i < 5) {
        billsList[i] = tmp[i < 4 ? i : i + budgetGoalNum];
        budgeted = budgeted + billsList[i].billAmount;
      }
    }

    /* for (int i = 0; i < 5; i++) {
      billsList[i] = tmp[i < 4 ? i : i + budgetGoalNum];

//      billsList[i].allSubBills = await databaseHelper.subBills(
//          budgetsList[currentBudget], billsList[i]);

      budgeted = budgeted + billsList[i].billAmount;
    } */
    budgetsList[currentBudget].allBills = tmp;

//    budgetsList[currentBudget].allBills = billsList;
    leftInBudgetVal = totalIncome - budgeted;
    setState(() {
      dataLoading = false;
    });
  }

  TextStyle _textStyle(bool isBold, double fSize) {
    return TextStyle(
        color: Color(
          Constant.whiteColor,
        ),
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
        fontSize: fSize);
  }

  Widget secRowBoxesList() {
    List<Widget> tmpList = List<Widget>();
    for (int i = 0; i < secRowStrings.length; i++) {
      tmpList.add(secRowBox(i));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, children: tmpList);
  }

  String reqString(double val) {
    int chuss = val.toString().indexOf('.');
    chuss++;

    int len = val.toString().substring(chuss).length;
    if (len < 2) {
      return val.toStringAsFixed(2);
    } else {
      return val.toString();
    }
  }

  Widget secRowBox(int itemNum) {
    return GestureDetector(
      onTap: itemNum == 0
          ? () async {
              double abc = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          IncomeBakchodi(budgetsList[currentBudget])));
              if (abc != null) {
                setState(() {
                  totalIncome = abc;
//                  leftInBudgetVal =
//                      totalIncome - budgetsList[currentBudget].budgeted;
                  leftInBudgetVal = totalIncome - budgeted;
                });
              }
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.35,
        height: 75.0,
        decoration: greenBorderBoxDecoration,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 62.5),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              secRowStrings[itemNum],
              style: smallTextStyle,
              textAlign: TextAlign.center,
              textScaleFactor: 0.95,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: itemNum < 2
                  ? Text(
                      "\$${itemNum == 0 ? reqString(totalIncome) : reqString(budgeted)}",
                      //reqString(budgetsList[currentBudget].budgeted)}",
                      style: mediumTextStyle,
                    )
                  : Text(
                      leftInBudgetVal < 0
                          ? "-\$${reqString(double.parse(leftInBudgetVal.toString().substring(1)))}"
                          : "\$${reqString(leftInBudgetVal)}",
                      style: TextStyle(
                          color:
                              leftInBudgetVal < 0 ? Colors.red : Colors.white,
                          fontSize: 20),
                    ),
            )
          ],
        )),
      ),
    );
  }

  Widget billsCol() {
    List<Widget> tmpList = List<Widget>();

    for (int i = 0; i < billsList.length; i++) {
      tmpList.add(billRow(billsList[i], i));
    }

    return Column(
      children: tmpList,
    );
  }

  Widget reqBox() {
    return Column(
      children: <Widget>[
        billListPointer == -1
            ? Container()
            : Text(
                "ADD ITEMS TO\n${whichBill}",
                style: largeTextStyle,
                textScaleFactor: 1.25,
                textAlign: TextAlign.center,
              ),
        billListPointer == -1 ? secRowBoxesList() : Container(),
        Container(
          height: billListPointer == -1
              ? MediaQuery.of(context).size.height / 100
              : 1.0,
        ),
        billsCol(),
        billListPointer == -1
            ? Container()
            : Column(children: subBillsWidgetsList + subBillButtons),
        billListPointer == -1
            ? GestureDetector(
                onTap: () {
                  Budget budgetTemp = Budget();
//                  Budget budgetTemp = budgetsList[currentBudget];
                  budgetTemp.budgetId = budgetsList[currentBudget].budgetId;
                  budgetTemp.allIncomes = budgetsList[currentBudget].allIncomes;
//               budgetTemp.allBills = budgetsList[]
                  budgetTemp.allBills = billsList;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => Results(
                              budgetTypeNum,
                              budgetGoalNum,
//                              budgetsList[currentBudget],
                              budgetTemp,
                              budgeted)));
                },
                child: greenButton('GO TO RESULTS   >'),
              )
            : Container(),
        Container(
          height: MediaQuery.of(context).size.height / 50,
        ),
        SizedBox(
          height: 10.0,
        ),
        billListPointer == -1 ? lastRow() : Container(),
      ],
    );
  }

  Widget billRow(Bill bill, int billNum) {
    return billListPointer == -1 || billListPointer == billNum
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              billNameCon(bill.billName, billNum),
              relatedValContainer(bill.billAmount),
            ],
          )
        : Container();
  }

  Widget relatedValFieldCon(TextEditingController valCon) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 200),
      padding: EdgeInsets.symmetric(),
      decoration: greyBoxDecoration,
      width: MediaQuery.of(context).size.width / 3.5,
      child: Center(
        child: TextFormField(
          controller: valCon,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: littleMediumTextStyle,
          keyboardType: TextInputType.number,
          validator: (txt) {
            if (txt != null && txt != '') {
              if (txt[0] == '\$') {
                txt = txt.substring(1);
              }
            }
            if (!isFloat(txt)) {
              valCon.text = "\$0";
            } else {
              valCon.text = '\$${txt}';
            }
          },
          onFieldSubmitted: (txt) {},
        ),
      ),
    );
  }

  Widget relatedValContainer(double val) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 200),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100,
          horizontal: MediaQuery.of(context).size.width / 30),
      decoration: BoxDecoration(
        color: Color(Constant.conColor),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(Constant.borderColor), width: 1.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              '\$${reqString(val)}',
              style: littleMediumTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget billNameCon(String txt, int billNum) {
    return GestureDetector(
      onTap: () {
        if (billListPointer == -1) {
          billListPointer = billNum;
          whichBill = billsList[billListPointer].billName;
          initializeSubBillsList(billsList[billListPointer]);
        } else {
          billListPointer = -1;
          subBillsWidgetsList.clear();
          subBillButtons.clear();
        }

        dropdownListOpened = !dropdownListOpened;
        setState(() {});
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 200),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 100,
            horizontal: MediaQuery.of(context).size.width / 25),
        decoration: greyBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  txt,
                  style: littleMediumTextStyle,
                ),
              ),
            ),
            Icon(
              dropdownListOpened ? Icons.expand_more : Icons.expand_less,
              color: Color(Constant.whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget addBtn() {
    return Container(
      decoration: greyBoxWithoutBorder,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100,
          horizontal: MediaQuery.of(context).size.width / 50),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100),
      child: Center(
        child: Text(
          '+',
          style: largeTextStyle,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(
      bool isGreyCon, bool isGreenBorder, bool borderNeeded) {
    return BoxDecoration(
        color: isGreyCon
            ? Color(isGreenBorder ? Constant.conColor : Constant.conColor2)
            : Color(Constant.greenColor),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: isGreenBorder
                ? Color(Constant.greenColor)
                : borderNeeded
                    ? Color(Constant.borderColor)
                    : Colors.transparent,
            width: 2.0));
  }

  Widget subBillRow(
      TextEditingController nameCon, TextEditingController valCon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[subBillContainer(nameCon), relatedValFieldCon(valCon)],
    );
  }

  initializeSubBillsList(Bill bill) {
    subBillsWidgetsList.clear();
    subBillButtons.clear();
    subBillNameTEControllers.clear();
    subBillValTEControllers.clear();

    for (int i = 0; i < bill.allSubBills.length; i++) {
      subBillNameTEControllers.add(TextEditingController());
      subBillValTEControllers.add(TextEditingController());
      subBillNameTEControllers[i].text = bill.allSubBills[i].subBillName;
      subBillValTEControllers[i].text =
          '\$${reqString(bill.allSubBills[i].subBillAmount)}';
      subBillsWidgetsList.add(
          subBillRow(subBillNameTEControllers[i], subBillValTEControllers[i]));
    }
    subBillButtons.add(
      GestureDetector(
        onTap: () {
          TextEditingController nameCon = TextEditingController();
          TextEditingController valCon = TextEditingController();
          subBillNameTEControllers.add(nameCon);
          subBillValTEControllers.add(valCon);

          int nameConIndex = subBillNameTEControllers.indexOf(nameCon);
          int valConIndex = subBillValTEControllers.indexOf(valCon);
          subBillsWidgetsList.add(subBillRow(
              subBillNameTEControllers[nameConIndex],
              subBillValTEControllers[valConIndex]));

          setState(() {});
        },
        child: addBtn(),
      ),
    );
    subBillButtons.add(GestureDetector(
      onTap: () {
        if (formKey.currentState.validate()) {
          addSubBills();
        }
      },
      child: greenButton("Done"),
    ));
  }

  Widget subBillContainer(TextEditingController nameCon) {
    double tmpMargin = 2.5;
    return Container(
      width: MediaQuery.of(context).size.width / 1.75,
      decoration: greyBoxWithoutBorder,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      margin: EdgeInsets.symmetric(vertical: tmpMargin),
//      margin: 1.0,
      child: TextFormField(
        controller: nameCon,
        validator: (txt) {},
        decoration: InputDecoration(
            errorStyle: smallTextStyle,
            border: InputBorder.none,
            hintText: "Expense name here ",
            hintStyle: littleMediumTextStyle),
        style: littleMediumTextStyle,
      ),
    );
  }

  addSubBills() async {
    setState(() {
      dataLoading = true;
    });
    double totalAmount = 0.0;
//    budgetsList[currentBudget].budgeted = budgetsList[currentBudget].budgeted -
//        billsList[billListPointer].billAmount;
    budgeted = budgeted - billsList[billListPointer].billAmount;
    billsList[billListPointer].allSubBills.clear();
    await databaseHelper.deleteSubBillsOfaBill(billsList[billListPointer]);
    for (int i = 0; i < subBillNameTEControllers.length; i++) {
      if (subBillNameTEControllers[i].text != '') {
        SubBill subBill = SubBill();
        subBill.subBillName = subBillNameTEControllers[i].text == ''
            ? Constant.noName
            : subBillNameTEControllers[i].text;
        subBill.subBillAmount =
            double.parse(subBillValTEControllers[i].text.substring(1));
        totalAmount = totalAmount + subBill.subBillAmount;
        subBill.budgetId = budgetsList[currentBudget].budgetId;
        subBill.billName = billsList[billListPointer].billName;

        billsList[billListPointer].allSubBills.add(subBill);
        await databaseHelper.insertSubBill(subBill);
      }
    }

    billsList[billListPointer].billAmount = totalAmount;
    await databaseHelper.updateBill(
        billsList[billListPointer], budgetsList[currentBudget]);
//    budgetsList[currentBudget].budgeted =
//        budgetsList[currentBudget].budgeted + totalAmount;
    budgeted = budgeted + totalAmount;
    await databaseHelper.updateBudget(budgetsList[currentBudget]);
    String incomeVal = '${totalIncome}';
    if (incomeVal[0] == '\$') {
      incomeVal = incomeVal.substring(1);
    }
//    double tmpDiff =
//        double.parse(incomeVal) - budgetsList[currentBudget].budgeted;
    double tmpDiff = double.parse(incomeVal) - budgeted;
    leftInBudgetVal = tmpDiff;
    billListPointer = -1;
    subBillValTEControllers.clear();
    subBillNameTEControllers.clear();
    setState(() {
      dataLoading = false;
    });
  }

  Widget greenButton(String btnName) {
    return Container(
      decoration: greenBoxDecoration,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100,
          horizontal: MediaQuery.of(context).size.width / 50),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100),
      child: Center(
        child: Text(
          btnName,
          style: mediumTextStyle,
        ),
      ),
    );
  }

  Widget appBartitle() {
    return Row(
      children: <Widget>[
        Image.asset(
          Constant.bigLogo,
          height: 60.0,
          width: 60.0,
          fit: BoxFit.fill,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(
          'BudgetCents',
          style: TextStyle(
            color: Color(Constant.whiteColor),
            fontWeight: FontWeight.w700,
            fontSize: 25.0,
          ),
        )
      ],
    );
  }

  Widget reqAppBar() {
    return Container(
//      padding: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        color: Color(Constant.appbarColor),
        boxShadow: [
          BoxShadow(
            color: Color(Constant.shadowColor),
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          leadingIcon(),
          appBartitle(),
          Container(),
        ],
      ),
    );
  }

  Widget leadingIcon() {
    return Container(
      decoration: BoxDecoration(
          color: Color(Constant.conColor2),
          border: Border.all(
            color: Color(Constant.whiteColor),
          ),
          borderRadius: BorderRadius.circular(10.0)),
      child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(Constant.whiteColor),
          ),
          onPressed: () {
            if (billListPointer == -1) {
              Navigator.pop(context);
//              showAlertDialog();
            } else {
              billListPointer = -1;
              setState(() {});
            }
          }),
    );
  }

  Widget lastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(),
        GestureDetector(
          child: Image.asset(
            calenderAsset,
            height: 112.5,
            width: 112.5,
            fit: BoxFit.contain,
          ),
          onTap: () async {
            await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().month),
                lastDate: DateTime(DateTime.now().year + 5));
          },
        ),
        GestureDetector(
          child: Image.asset(
            calculatorAsset,
            height: 112.5,
            width: 112.5,
            fit: BoxFit.contain,
          ),
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: showCalculatorWidget());
                });
          },
        ),
        Container(),
      ],
    );
  }

  Widget showCalculatorWidget() {
    double _currentValue = 0;
    return SimpleCalculator(
      value: _currentValue,
      hideExpression: false,
      hideSurroundingBorder: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value;
        });
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: 2,
        displayColor: Colors.black,
        displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
        expressionColor: Colors.indigo,
        expressionStyle: const TextStyle(fontSize: 20, color: Colors.white),
        operatorColor: Colors.pink,
        operatorStyle: const TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Colors.orange,
        commandStyle: const TextStyle(fontSize: 30, color: Colors.white),
        numColor: Colors.grey,
        numStyle: const TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
  }
}
