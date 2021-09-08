import 'package:budgetcents/inside_app/budget_preparation.dart';
//import 'package:budgetcents/res/static_info.dart';
import 'package:flutter/material.dart';
//import 'package:budgetcents/auth/login.dart';
import 'package:budgetcents/res/basic_logo.dart';
import 'package:budgetcents/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../inside_app/budget_preparation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    checkUser();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => BudgetPreparation()),
          (predicate) => false);
    });
  }

//  bool internetConnected;
  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constant.backgroundColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BasicLogo(true),
          ],
        ),
      ),
    );
  }
}
