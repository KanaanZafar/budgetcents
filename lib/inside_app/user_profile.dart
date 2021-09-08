import 'package:budgetcents/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<String> linksNames = ['Privacy Policy', 'Terms & Conditions', 'FAQ'];
  List<String> linkUrls = [
    'http://budgetcents.us/privacy-policy/',
    'http://budgetcents.us/terms-and-conditions/',
    'http://budgetcents.us/faq'
  ];
  List<String> socialAddressses = [
    'https://www.facebook.com/centsbudget/',
    'https://twitter.com/centsbudget/',
    'https://www.instagram.com/centsbudget/'
  ];

//  int linkNum = -1;
  TextStyle boldStyle;
  TextStyle normalStyle;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//  DatabaseReference dbref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    boldStyle = _textStyle(true);
    normalStyle = _textStyle(false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(Constant.backgroundColor),
      appBar: PreferredSize(
        child: reqAppBar(),
        preferredSize: Size.fromHeight(100.0),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          linksCol(), //btnsCol()
          Container(),
//          Container(),
          linksRow(),
          Container()
        ],
      ),
    ));
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

//Widget userName(){}
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

  TextStyle _textStyle(bool isBold) {
    return TextStyle(
        color: Color(Constant.whiteColor),
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w400);
  }

  Widget linksCol() {
    List<Widget> tmp = List<Widget>();
    for (int i = 0; i < linksNames.length; i++) {
      tmp.add(linkContainer(i));
    }
    return Column(children: tmp);
  }

  Widget linksRow() {
    List<Widget> tmp = List<Widget>();
    for (int i = 0; i < Constant.socialLinks.length; i++) {
      tmp.add(
        GestureDetector(
          child: Image.asset(
            Constant.socialLinks[i],
            height: 75.0,
            width: 75.0,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
          ),
          onTap: () async {
            if (await canLaunch(socialAddressses[i])) {
              launch(socialAddressses[i]);
            } else {
              _showSnackBar(
                  'Error launching in given url: ${socialAddressses[i]}');
            }
          },
        ),
      );
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: tmp);
  }

  Widget linkContainer(int lNum) {
    return GestureDetector(
      onTap: () {
        _launchURL(lNum);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 100),
        decoration: BoxDecoration(
          color: Color(Constant.conColor2),
          border: Border.all(
            color: Color(Constant.borderColor),
          ),
        ),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 100,
            horizontal: MediaQuery.of(context).size.width / 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              linksNames[lNum],
              style: normalStyle,
              textScaleFactor: 1.5,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(Constant.whiteColor),
            )
          ],
        ),
      ),
    );
  }

  _launchURL(int urlNum) async {
    String url = linkUrls[urlNum];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
//      throw 'Could not launch $url';
      _showSnackBar('Could not launch ${url}');
    }
  }

  _showSnackBar(String chithi) {
    SnackBar snackBar = SnackBar(content: Text(chithi));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

//  showSnackBar(String chithi) {
//    SnackBar snackBar = SnackBar(content: Text(chithi));
//    scaffoldKey.currentState.showSnackBar(snackBar);
//  }
}
