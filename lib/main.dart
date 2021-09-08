//import 'package:budgetcents/res/static_info.dart';
import 'package:flutter/material.dart';
import 'package:budgetcents/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetCents',
      theme: ThemeData(fontFamily: 'Nunito'),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
