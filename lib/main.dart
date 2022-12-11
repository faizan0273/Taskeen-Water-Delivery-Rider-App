import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
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
      backgroundColor: Colors.white,
      body: Container(
        decoration:BoxDecoration(
          image:DecorationImage(
            scale: 1.0,
            image: AssetImage('assets/logo.jpg'),
          ),
        ),
      ),
    );
  }
}



