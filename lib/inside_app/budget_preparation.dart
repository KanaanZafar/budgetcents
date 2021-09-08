import 'dart:io';

import 'package:budgetcents/database_helper/database_helper.dart';
import 'package:budgetcents/inside_app/calculations.dart';
import 'package:budgetcents/inside_app/user_profile.dart';
import 'package:budgetcents/models/bill.dart';
import 'package:budgetcents/models/budgets.dart';
import 'package:budgetcents/models/income.dart';
import 'package:budgetcents/models/sub_bill.dart';
import 'package:budgetcents/res/constants.dart';

//import 'package:budgetcents/res/static_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BudgetPreparation extends StatefulWidget {
  @override
  _BudgetPreparationState createState() => _BudgetPreparationState();
}

class _BudgetPreparationState extends State<BudgetPreparation> {
//  bool appearBackIcon = false;
//  List mainList = ['BUDGET TYPE', 'BUDGET GOAL'];
  List<String> mainList;
  int mainListPointer = -1;
  List<List<String>> listOfLists = [Constant.budgetTypes, Constant.budgetGoals];
  int budgetTypesPointer = -1;
  int budgetGoalsPointer = -1;
  EdgeInsets _margin = EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0);
  EdgeInsets _padding = EdgeInsets.symmetric(vertical: 10.0);
  String budgetType = 'BUDGET TYPE';
  String budgetGoal = 'BUDGET GOAL';
  List<Budget> budgetsList;
  SharedPreferences sharedPreferences;
  bool sharedPreferencesLoaded;
  String btnText = '';
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool dataLoaded;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Bill> billsList;
  List<Income> incomesList;
  String txt1 = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainList = [budgetType, budgetGoal];

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(
        Constant.backgroundColor,
      ),
      appBar: PreferredSize(
        child: reqAppBar(),
        preferredSize: Size.fromHeight(100.0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
//              reqAppBar(),
//              Container(),
            welcometxt(),
//              Container(),
            Column(
              children: <Widget>[
                txtWid('BUDGET PREPARATION', 30, true),
                txtWid(
                    'Before we start your budget,\nwe need to know what you want',
                    20,
                    false),
              ],
            ),

            sharedPreferencesLoaded == true
                ? centralCol()
                : LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
            Container(),
//              Container(),
            budgetTypesPointer != -1 && budgetGoalsPointer != -1
                ? doneBtn()
                : Container(),
//              Container(),
//            linksRow(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }

  Widget headingTxt(int num) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 2.5,
        horizontal: 30.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: txtWid(
            num == 0 ? 'Income Frequency' : "Budgeting Goals", 25, false),
      ),
    );
  }

  Widget txtWid(String msg, double fSize, bool isBold) {
    return Text(
      msg,
      style: TextStyle(
          color: Color(
            Constant.whiteColor,
          ),
          fontSize: fSize,
          fontWeight: isBold == true ? FontWeight.w700 : FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }

  Widget customDropDown(int itemNum) {
    return GestureDetector(
      onTap: () {
        if (mainListPointer == -1) {
          mainListPointer = itemNum;
//          appearBackIcon = true;
        } else {
//          appearBackIcon = false;
          mainListPointer = -1;
        }
        setState(() {});
      },
      child: outerContainer(Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            txtWid(mainList[itemNum], 20, false),
            Icon(
              mainListPointer == itemNum
                  ? Icons.expand_less
                  : Icons.expand_more, //size: 30.0,
              color: Color(Constant.whiteColor),
            )
          ],
        ),
      )),
    );
  }

  Widget outerContainer(Widget widget) {
    return Container(
        margin: _margin,
        padding: _padding,
        decoration: BoxDecoration(
          color: Color(Constant.conColor),
          border: Border.all(
            color: Color(Constant.borderColor),
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: widget);
  }

  Widget subList(int listNum) {
    List<Widget> tempList = List<Widget>();
    for (int i = 0; i < listOfLists[listNum].length; i++) {
      tempList.add(sublistItem(listNum, i));
    }
    return Column(children: tempList);
  }

  Widget sublistItem(int whichMainList, int itemNum) {
    return GestureDetector(
      onTap: () {
        if (whichMainList == 0) {
          budgetTypesPointer = itemNum;
          mainList[0] = Constant.budgetTypes[budgetTypesPointer];
        } else {
          budgetGoalsPointer = itemNum;
          mainList[1] = Constant.budgetGoals[budgetGoalsPointer];
        }
        mainListPointer = -1;
        setState(() {});
        if (budgetTypesPointer != -1 && budgetGoalsPointer != -1) {
          setSharedPreferencesData();
        }
      },
      child: Container(
        margin: _margin,
        padding: _padding,
        decoration: BoxDecoration(
          color: Color(Constant.conColor),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: whichMainList == 0
                  ? budgetTypesPointer == itemNum
                      ? Color(Constant.greenColor)
                      : Colors.transparent
                  : budgetGoalsPointer == itemNum
                      ? Color(Constant.greenColor)
                      : Colors.transparent,
              width: 3.0),
        ),
        child: Center(
          child: txtWid(
              whichMainList == 0
                  ? Constant.budgetTypes[itemNum]
                  : Constant.budgetGoals[itemNum],
              20,
              false),
        ),
      ),
    );
  }

  Widget centralCol() {
    return Column(
      children: <Widget>[
        mainListPointer == -1 || mainListPointer == 0
            ? Column(
                children: <Widget>[
                  headingTxt(0),
                  customDropDown(0),
                ],
              )
            : Container(),
        mainListPointer == -1 || mainListPointer == 1
            ? Column(
                children: <Widget>[
                  headingTxt(1),
                  customDropDown(1),
                ],
              )
            : Container(),
        mainListPointer != -1 ? subList(mainListPointer) : Container()
      ],
    );
  }

  Widget doneBtn() {
    return Padding(
      padding: _margin,
      child: dataLoaded == true
          ? RaisedButton(
              onPressed: () {
                dealDone();
              },
              color: Color(Constant.greenColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
//        margin: _margin,
                width: MediaQuery.of(context).size.width,
                padding: _padding,
                decoration: BoxDecoration(
                  color: Color(
                    Constant.greenColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(child: txtWid(btnText, 20, false)),
              ),
            )
          : CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Color(Constant.whiteColor)),
            ),
    );
  }

  loadData() async {
    await getSharedPreferencesData();
    setState(() {
      sharedPreferencesLoaded = true;
    });
    budgetsList = await databaseHelper.allBudgets();
    if (budgetsList.length > 0) {
      budgetsList.sort((a, b) => a.budgetId.compareTo(b.budgetId));

      billsList = await databaseHelper
          .relatedBills(budgetsList[budgetsList.length - 1]);

    print('0000 ${billsList.length}');
      incomesList = await databaseHelper
          .relatedIncomes(budgetsList[budgetsList.length - 1]);

      for (int i = 0; i < billsList.length; i++) {
        List<SubBill> subBillsList = await databaseHelper.subBills(
            budgetsList[budgetsList.length - 1], billsList[i]);
        billsList[i].allSubBills = subBillsList;
      }
      budgetsList[budgetsList.length - 1].allBills = billsList;
//      budgetsList[budgetsList.length - 1].allBills = List<Bill>();
      budgetsList[budgetsList.length - 1].allIncomes = incomesList;
    } else {
      billsList = List<Bill>();
      incomesList = List<Income>();
    }
    setState(() {
      dataLoaded = true;
    });
  }

  dealDone() async {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Calculations(budgetTypesPointer, budgetGoalsPointer,
            budgetsList //, billsList, subMaps
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
          Container(),
          appBartitle(),
          trailingIcon(),
        ],
      ),
    );
  }

  Widget trailingIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Color(Constant.conColor2),
        border: Border.all(
          color: Color(Constant.whiteColor),
        ),
        shape: BoxShape.circle,
      ),
//      padding: EdgeInsets.all(10.0),
      child: IconButton(
          icon: Icon(
//            Icons.person,
            Icons.menu,
            color: Color(Constant.whiteColor),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => Profile()));
          }),
    );
  }

  getSharedPreferencesData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getInt(Constant.budgetTypeNum) != null) {
      budgetTypesPointer = sharedPreferences.getInt(Constant.budgetTypeNum);
      budgetGoalsPointer = sharedPreferences.getInt(Constant.budgetGoalNum);
      setState(() {
        btnText = 'Take me back to my budget';
        txt1 = 'Welcome Back';
        mainList[0] = Constant.budgetTypes[budgetTypesPointer];
        mainList[1] = Constant.budgetGoals[budgetGoalsPointer];
      });
    } else {
      setState(() {
        txt1 = 'Welcome';
//       txt2 =
//       '';
        btnText = 'DONE';
      });
    }
  }

  setSharedPreferencesData() async {
    await sharedPreferences.setInt(Constant.budgetTypeNum, budgetTypesPointer);
    await sharedPreferences.setInt(Constant.budgetGoalNum, budgetGoalsPointer);
  }

  Widget welcometxt() {
    return Column(
      children: <Widget>[
        txtWid(txt1, 22, false),
//        txtWid(StaticInfo.userName, 30, true)
      ],
    );
  }
}
