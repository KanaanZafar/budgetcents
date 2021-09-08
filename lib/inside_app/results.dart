import 'package:after_init/after_init.dart';
import 'package:budgetcents/models/budgets.dart';
//import 'package:budgetapp/models/specific_budget.dart';

//import 'package:budgetapp/models/monthly_budget.dart';
import 'package:budgetcents/res/constants.dart';

import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  int budgetTypeNum;
  int budgetGoalNum;
  Budget budgetToDealWith;
  double budgeted;

  Results(this.budgetTypeNum, this.budgetGoalNum, this.budgetToDealWith,
      this.budgeted);

  @override
  _ResultsState createState() =>
      _ResultsState(budgetTypeNum, budgetGoalNum, budgetToDealWith, budgeted);
}

class _ResultsState extends State<Results> with AfterInitMixin<Results> {
  int budgetTypeNum;
  int budgetGoalNum;
  Budget budgetToDealWith;
  double budgeted;

  _ResultsState(this.budgetTypeNum, this.budgetGoalNum, this.budgetToDealWith,
      this.budgeted);

  String budgetType = '';
  TextStyle boldTextStyle;
  TextStyle normalTextStyle;
  BoxDecoration greyBorder;
  BoxDecoration greenBorder;
  BoxDecoration greenBox;
  int billsPointer = -1;
  bool isListExpanded;
  EdgeInsets _padding;

//  List<BudgetOfSpecificSection> specificBudgets;
  int budgetsListPointer = -1;
  int totalBudgets;

//  EdgeInsets _margin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    budgetType = Constant.budgetTypes[budgetTypeNum];
    boldTextStyle = _textStyle(true);
    normalTextStyle = _textStyle(false);
    greyBorder = _decoration(false, false);
    greenBorder = _decoration(true, false);
    greenBox = _decoration(false, true);
//    specificBudgets = budgetToDealWith.allSpecificBudgets;

    if (budgetTypeNum == 0) {
      totalBudgets = 4;
    } else if (budgetTypeNum == 1) {
      totalBudgets = 2;
    } else {
      totalBudgets = 1;
    }
    setState(() {});
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    _padding = EdgeInsets.symmetric(
        horizontal: MediaQuery
            .of(context)
            .size
            .width / 50,
        vertical: MediaQuery
            .of(context)
            .size
            .height / 100);
//    _padding = _margin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: reqAppBar(), preferredSize: Size.fromHeight(100.0)),
      backgroundColor: Color(Constant.backgroundColor),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 50,
            ),
            budgetTypeHeading(),
            specificBudgetWidgetsList()
          ],
        ),
      ),
    );
  }

  Widget specificBudgetWidgetsList() {
    List<Widget> tmp = List<Widget>();
    for (int i = 0; i < totalBudgets; i++) {
      tmp.add(specificBudgetWidget(i));
    }
    return Column(
      children: tmp,
    );
  }

  Widget specificBudgetWidget(int budgetNumber) {
    return budgetsListPointer == -1 || budgetsListPointer == budgetNumber
        ? Column(
      children: <Widget>[
        budgetTypeNum == 2
            ? Container()
            : greenContainerText(budgetNumber + 1),
        billsCol(budgetNumber),
        billsPointer == -1
            ? Container()
            : subBillCol(billsPointer, budgetNumber),
        billsPointer == -1 ? totalContainer(budgetNumber) : Container(),
      ],
    )
        : Container();
  }

  TextStyle _textStyle(bool isBold) {
    return TextStyle(
      color: Color(Constant.whiteColor),
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
    );
  }

  BoxDecoration _decoration(bool isGreenBorder, bool isGreenColor) {
    return BoxDecoration(
      color:
      Color(isGreenColor == true ? Constant.greenColor : Constant.conColor),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Color(
            isGreenBorder == true ? Constant.greenColor : Constant.borderColor),
        width: isGreenBorder == true ? 2.0 : 1.0,
      ),
    );
  }

  Widget budgetTypeHeading() {
    return Text(
      budgetType,
      style: boldTextStyle,
      textScaleFactor: 2.0,
    );
  }

  Widget billNameContainer(int billNum, int budgNum) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 1.5,
      decoration: greyBorder,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery
              .of(context)
              .size
              .width / 50,
          vertical: MediaQuery
              .of(context)
              .size
              .height / 100),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery
              .of(context)
              .size
              .width / 50,
          vertical: MediaQuery
              .of(context)
              .size
              .height / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width / 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
//                budgetToDealWith.allBills[billNum].billType,
                budgetToDealWith.allBills[billNum].billName,
                style: normalTextStyle,
                textScaleFactor: 1.25,
              ),
            ),
          ),
          Icon(
            isListExpanded != true ? Icons.expand_more : Icons.expand_less,
            color: Color(Constant.whiteColor),
          ),
        ],
      ),
    );
  }

  Widget billsCol(int budgetNumber) {
    List<Widget> tmp = List<Widget>();

//    for (int i = 0; i < budgetToDealWith.allBills.length; i++) {
     for(int i=0; i<5;i++){
      tmp.add(billRow(i, budgetNumber));
    }
    return Column(children: tmp);
  }

  Widget billRow(int billNum, int budgNum) {
    return GestureDetector(
      onTap: () {
        if (budgetsListPointer == -1) {
          budgetsListPointer = budgNum;
        } else {
          budgetsListPointer = -1;
        }

        if (billsPointer == -1) {
          billsPointer = billNum;
          isListExpanded = true;
        } else {
          billsPointer = -1;
          isListExpanded = false;
        }
        setState(() {});
      },
      child: billsPointer == -1 || billsPointer == billNum
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          billNameContainer(billNum, budgNum),
          relatedValCon(billNum, budgNum),
        ],
      )
          : Container(),
    );
  }

  String reqString(double val) {
    int chuss = val.toString().indexOf('.');
    chuss++;

    int len = val
        .toString()
        .substring(chuss)
        .length;
    if (len < 2) {
      return val.toStringAsFixed(2);
    } else {
      return val.toString();
    }
  }

  Widget relatedValCon(int billNum, int budgNum) {
    double relatedVal =
        budgetToDealWith.allBills[billNum].billAmount / totalBudgets;
//    String valString = '';
//    if (relatedVal == 0.0) {
//      valString = '0';
//    } else {
//      valString = '${relatedVal}';
//    }
    return Container(
      decoration: greyBorder,
      padding: _padding,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery
              .of(context)
              .size
              .height / 100),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 6,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
//            '\$${budgetToDealWith.allBills[billNum].billAmount / totalBudgets}',
            '\$${reqString(relatedVal)}',
            style: normalTextStyle,
            textScaleFactor: 1.125,
          ),
        ),
      ),
    );
  }

  Widget subBillNameCon(String subBillName) {
    return Container(
      decoration: greyBorder,
      width: MediaQuery
          .of(context)
          .size
          .width / 1.75,
      padding: _padding,
      margin: _padding,
      child: SingleChildScrollView(
        child: Text(
          subBillName,
          style: normalTextStyle,
          textScaleFactor: 1.125,
        ),
      ),
    );
  }

  Widget subBillCol(int whichBillNum, int budgNum) {
    List<Widget> tmp = List<Widget>();
    for (int i = 0;
    i < budgetToDealWith.allBills[whichBillNum].allSubBills.length;
    i++) {
      tmp.add(subBillRow(whichBillNum, i, budgNum));
    }
    return Column(children: tmp);
  }

  Widget subBillRow(int billNum, int subBillNum, int budgNum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        subBillNameCon(budgetToDealWith
            .allBills[billNum].allSubBills[subBillNum].subBillName),
        relatedsubValCon(budgetToDealWith
            .allBills[billNum].allSubBills[subBillNum].subBillAmount)
      ],
    );
  }

  Widget relatedsubValCon(double subBillVal) {
    double relatedVal = subBillVal / totalBudgets;
    return Container(
      decoration: greyBorder,
      width: MediaQuery
          .of(context)
          .size
          .width / 6,
      padding: _padding,
      margin: _padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          '\$${reqString(relatedVal)}',
          style: normalTextStyle,
          textScaleFactor: 1.125,
        ),
      ),
    );
  }

  Widget totalContainer(int budgetNum) {
//    double totalval = budgetToDealWith.budgeted / totalBudgets;
    double totalval =budgeted / totalBudgets;
    String valString = '';
    if (totalval == 0.0) {
      valString = '0';
    } else {
      valString = '${totalval}';
    }
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 50.0,
      decoration: greenBorder,
      padding: _padding,
      margin: _padding,
      child: Center(
        child: Text(
          'Total  \$${valString}',
          style: boldTextStyle,
          textScaleFactor: 2.25,
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
            Navigator.pop(context);
          }),
    );
  }

  Widget greenContainerText(int btnNum) {
    return Container(
      decoration: greenBox,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery
              .of(context)
              .size
              .height / 100,
          horizontal: MediaQuery
              .of(context)
              .size
              .width / 50),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery
              .of(context)
              .size
              .height / 100),
      child: Center(
        child: Text(
          "PAY CHECK ${btnNum}",
          textScaleFactor: 1.5,
          style: normalTextStyle,
        ),
      ),
    );
  }
}
