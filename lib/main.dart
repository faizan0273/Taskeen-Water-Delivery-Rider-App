import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:taskeen/homeScreen.dart';
import 'package:taskeen/reportScreen.dart';
import 'package:taskeen/utils/config.dart';
import 'package:taskeen/viewScreen.dart';

import 'customerScreen.dart';


Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskeen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splashScreen',
      routes: {
        '/splashScreen': (context) => splashScreen(),
        '/homeScreen': (context) => homeScreen(),
        '/customerScreen': (context) => customerScreen(),
        '/reportScreen': (context) => reportScreen(),
        '/viewScreen': (context) => viewScreen(profileId: '',),

      },
    ));
  });
}

class splashScreen extends StatefulWidget{
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  initState(){
    super.initState();
    Timer(Duration(seconds: 5),() {
      Navigator.pushNamed(context, '/homeScreen',);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset("assets/logo.png"),
            ),
            SizedBox(height: 50,),
            CircularProgressIndicator(
              backgroundColor: Colors.green,
              strokeWidth: 4,

            ),
            SizedBox(height: 100,),
            Text(" 0332-1424595",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}



