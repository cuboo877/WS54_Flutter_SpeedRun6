import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/page/login.dart';
import 'package:ws54_flutter_speedrun6/service/sharedPref.dart';

import 'home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void delayNav() async {
    await Future.delayed(const Duration(milliseconds: 250));
    String loggedID = await SharedPref.getLoggedUserID();
    print(loggedID);
    if (loggedID.isNotEmpty) {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(userID: loggedID)));
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    delayNav();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(width: double.infinity, child: Column()),
      ),
    );
  }
}
