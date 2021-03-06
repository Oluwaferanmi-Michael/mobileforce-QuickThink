import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottom_navigation_bar.dart';
import '../registration.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SharedPrefs sharedPrefs = SharedPrefs();
  String username;

  @override
  void initState() {
    super.initState();
    getUserName();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 5), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        username = pref.getString('Username');
      });

      if (username == null) {
        //Replace with Registration Route
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Registration(),
          ),
        );
      } else {
        ///Replace with Dashboard Route
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      }
    });
  }

  void getUserName() async {
    String name = await sharedPrefs.getUsername();
    setState(() {
      username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      //Background color
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildVector(height, width),
          _buildAppName(height, width),
          _buildLoader(height, width),
        ],
      ),
    );
  }

  //Loader
  Widget _buildLoader(double height, double width) {
    return Positioned(
        top: height * 0.57,
        left: width * 0.45,
        child: SpinKitThreeBounce(
          color: Color(0xFF18C5D9),
          size: 25,
        ));
  }

//Vector Image
  Widget _buildVector(height, width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/splash_vector.png',
          ),
          //   fit: BoxFit.scaleDown
        ),
      ),
    );
  }

  /// AppName
  Widget _buildAppName(height, width) {
    return Center(
      child: Container(
        child: RichText(
          text: TextSpan(
            text: 'Quick',
            style: GoogleFonts.dmSans(
              fontSize: 32,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Think',
                style: GoogleFonts.dmSans(
                  fontSize: 32,
                  color: Color(0xFF18C5D9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SharedPrefs {
  SharedPreferences sharedPreferences;

  /// Set Username
  Future<void> setUsername(String username) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final key = "Username";
    final storedValue = username;
    sharedPreferences.setString(key, storedValue);
  }

//Get Username
  Future<String> getUsername() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final key = "Username";
    final userStored = sharedPreferences.getString(key) ?? '0';

    return userStored;
  }
}
