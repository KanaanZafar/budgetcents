import 'package:flutter/material.dart';
import 'package:budgetcents/res/constants.dart';

class BasicLogo extends StatelessWidget {
  bool fromSplashScreen;

  BasicLogo(this.fromSplashScreen);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Image.asset(
            Constant.bigLogo,
            height: fromSplashScreen == true ? 150.0 : 100.0,
            width: fromSplashScreen == true ? 150.0 : 100.0,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: fromSplashScreen == true ? 15.0 : 10.0,
        ),
        Text(
          'BudgetCents',
          style: textStyle(true),

        ),
      lastText()
      ],
    );
  }

  TextStyle textStyle(bool isBold) {
    return TextStyle(
        color: Colors.white,
        fontSize: isBold == true
            ? fromSplashScreen == true ? 40 : 25
            : fromSplashScreen == true ? 20 : 12.5,
        fontWeight: isBold == true ? FontWeight.w700 : FontWeight.w400);
  }

  Widget lastText() {
    List<TextSpan> textSpans = List<TextSpan>.generate(3, (span) {
      return TextSpan();
    });
    textSpans[0] = TextSpan(
        text: "Budget",
        style: TextStyle(color: Color(Constant.greenColor), fontSize: 20.0));
    textSpans[1] = TextSpan(
      text: 'Cents ',
      style: TextStyle(
          color: Color(Constant.whiteColor),
          fontWeight: FontWeight.bold,
          fontSize: 20.0),
    );
    textSpans[2] = TextSpan(
      text: 'Makes Sense',
      style: TextStyle(color: Color(Constant.greenColor), fontSize: 20.0),
    );
    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: TextAlign.center,
    );
  }
}
