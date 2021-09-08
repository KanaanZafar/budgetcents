import 'package:after_init/after_init.dart';
import 'package:budgetcents/database_helper/database_helper.dart';
import 'package:budgetcents/inside_app/calculations.dart';
import 'package:budgetcents/models/budgets.dart';
import 'package:budgetcents/models/income.dart';
import 'package:budgetcents/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';

class IncomeBakchodi extends StatefulWidget {
//  Widget reqAppBar;
  Budget budget;

  IncomeBakchodi(this.budget);

  @override
  _IncomeBakchodiState createState() => _IncomeBakchodiState(budget);
}

class _IncomeBakchodiState extends State<IncomeBakchodi>
    with AfterInitMixin<IncomeBakchodi> {
//  Widget reqAppBar;
  Budget budget;

  _IncomeBakchodiState(this.budget);

  List<TextEditingController> nameControllers = List<TextEditingController>();
  List<TextEditingController> valControllers = List<TextEditingController>();
  List<int> dates = List<int>();
  List<Widget> incomeWidgetList = List<Widget>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  double totalInc = 0.0;
  DateFormat formatter = DateFormat('MM-dd-yyyy');

//  List<Income> incomesList = List<Income>();
  List<Income> incomesList;
  List<FontWeight> fontWeights = [
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
    FontWeight.w800,
    FontWeight.w900
  ];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool saving = false;
  bool hasDataChanged = false;

  @override
  void didInitState() {
    // TODO: implement didInitState
    incomesList = budget.allIncomes;
    for (int i = 0; i < incomesList.length; i++) {
      nameControllers
          .add(TextEditingController(text: incomesList[i].incomeSourceName));
      valControllers.add(TextEditingController(
          text: '\$${reqString(incomesList[i].incomeAmount)}'));
      dates.add(incomesList[i].incomeDate);
      incomeWidgetList.add(incomeRow(i, i, i));
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(Constant.backgroundColor),
        appBar: PreferredSize(
          child: reqAppBar(),
          preferredSize: Size.fromHeight(100.0),
        ),
        bottomNavigationBar: Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              reqBtn(true),
              reqBtn(false),
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            if (hasDataChanged == true) {
              showAlertDialog();
            } else {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 100,
                horizontal: MediaQuery.of(context).size.width / 35),
            child: Center(
              child: saving == false
                  ? SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Add your incomes',
                              style: textStyle(3),
                              textScaleFactor: 1.25,
                            ),
                            Column(children: incomeWidgetList),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Saving",
                          style: textStyle(3),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 20,
                        ),
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle(int fNum) {
    return TextStyle(color: Colors.white, fontWeight: fontWeights[fNum]);
  }

  Widget incomeRow(int nameConNum, int valConNum, int dateNum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        reqField(nameConNum, true),
        GestureDetector(
            onTap: () async {
              DateTime picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 2, 1),
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked != null) {
                if (hasDataChanged != true) {
                  hasDataChanged = true;
                }
                dates[dateNum] = picked.millisecondsSinceEpoch;

                setState(() {
                  incomeWidgetList[dateNum] =
                      incomeRow(dateNum, dateNum, dateNum);
                });
              }
            },
            child: dateBox(dateNum)),
        reqField(valConNum, false)
      ],
    );
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

  Widget dateBox(int dateNum) {
    return Container(
      decoration: BoxDecoration(
        color: Color(Constant.conColor2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width / 4.0,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            formatter
                .format(DateTime.fromMillisecondsSinceEpoch(dates[dateNum])),
            style: textStyle(2),
            textScaleFactor: 1.125,
          ),
        ),
      ),
    );
  }

  Widget reqField(int conNum, bool forName) {
    return Container(
      width: forName
          ? MediaQuery.of(context).size.width / 2.5
          : MediaQuery.of(context).size.width / 4.5,
      margin: EdgeInsets.symmetric(vertical: 2.5),
//      padding: EdgeInset,

      child: TextFormField(
        controller: forName ? nameControllers[conNum] : valControllers[conNum],
        decoration: InputDecoration(
          border: outlineInputBorder(!forName),
          focusedErrorBorder: outlineInputBorder(!forName),
          focusedBorder: outlineInputBorder(!forName),
          errorBorder: outlineInputBorder(!forName),
          enabledBorder: outlineInputBorder(!forName),
          disabledBorder: outlineInputBorder(!forName),
          fillColor: Color(Constant.conColor),
          filled: true,
          errorStyle: TextStyle(color: Colors.white),
          hintText: forName ? "Income Source Name" : "0.0",
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: textStyle(2),
        keyboardType: forName ? TextInputType.text : TextInputType.number,
        onChanged: (txt) {
          if (hasDataChanged != true) {
            hasDataChanged = true;
          }
        },
        validator: (txt) {
          if (hasDataChanged != true) {
            hasDataChanged = true;
          }
          if (forName == false) {
            if (txt != null && txt != '') {
              if (txt[0] == '\$') {
                txt = txt.substring(1);
              }
            }
            if (!isFloat(txt)) {
              valControllers[conNum].text = "\$0.0";
            } else {
              valControllers[conNum].text = '\$${txt}';
            }
          }
        },
      ),
    );
  }

  OutlineInputBorder outlineInputBorder(bool isForName) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
          color: isForName ? Colors.transparent : Color(Constant.whiteColor),
          width: 1.0),
    );
  }

  Widget reqBtn(bool isAddBtn) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100),
      child: RaisedButton(
        onPressed: () {
          if (isAddBtn) {
            TextEditingController textEditingController0 =
                TextEditingController();
            TextEditingController textEditingController1 =
                TextEditingController(text: "\$0.0");
            int a = DateTime.now().millisecondsSinceEpoch;

            nameControllers.add(textEditingController0);
            valControllers.add(textEditingController1);
            dates.add(a);
            int index0 = nameControllers.indexOf(textEditingController0);
            int index1 = valControllers.indexOf(textEditingController1);
            int index2 = dates.indexOf(a);
            incomeWidgetList.add(incomeRow(index0, index1, index2));
            if (hasDataChanged != true) {
              hasDataChanged = true;
            }
            setState(() {});
          } else {
            saveAllIncomes();
          }
        },
        color: Color(isAddBtn ? Constant.conColor : Constant.greenColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: isAddBtn
                ? Icon(
                    Icons.add,
                    color: Color(Constant.whiteColor),
                  )
                : Text(
                    "Done",
                    style: textStyle(3),
                  ),
          ),
        ),
      ),
    );
  }

  showAlertDialog() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Color(Constant.conColor),
      title: Text(
        "Do you want to save the changes?",
        style: textStyle(2),
      ),
      content: Text(
        "If you press No, all changes will be lost.",
        style: textStyle(2),
      ),
      actions: <Widget>[dialogBtn(true), dialogBtn(false)],
    );
    showDialog(
        context: context,
        builder: (ctx) {
          return alertDialog;
        });
  }

  dialogBtn(bool isNo) {
    return RaisedButton(
      onPressed: () {
//        Navigator.pop(context);
        if (isNo == true) {
          Navigator.pop(context);
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
          saveAllIncomes();
        }
      },
      color: Color(Constant.greenColor),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        isNo ? 'No' : 'Yes',
        style: textStyle(2),
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
          if (hasDataChanged == true) {
            showAlertDialog();
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  saveAllIncomes() async {
    if (formKey.currentState.validate()) {
      setState(() {
        saving = true;
      });
      await databaseHelper.deleteAllIncomes(budget);
      budget.allIncomes.clear();
      for (int i = 0; i < nameControllers.length; i++) {
//        if (nameControllers[i].text != '') {
        Income tmpIncome = Income();
        tmpIncome.incomeSourceName =
            nameControllers[i].text != '' ? nameControllers[i].text : "No Name";
        tmpIncome.incomeDate = dates[i];
        tmpIncome.budgetId = budget.budgetId;
        tmpIncome.incomeAmount =
            double.parse(valControllers[i].text.substring(1));
        totalInc = totalInc + tmpIncome.incomeAmount;

        budget.allIncomes.add(tmpIncome);
        await databaseHelper.insertIncome(tmpIncome);
//        }
      }
      setState(() {
        saving = false;
      });
      Navigator.pop(context, totalInc);
    }
  }
}
