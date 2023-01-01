import 'package:animated_background/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskeen/reportScreen.dart';
import 'package:taskeen/utils/firebase.dart';
import 'package:taskeen/values/values.dart';
import 'package:taskeen/widgets/clipShadowPath.dart';
import 'package:taskeen/widgets/custom_button.dart';
import 'package:taskeen/widgets/custom_shape_clippers.dart';
import 'package:taskeen/widgets/custom_text_form_field.dart';
import 'package:taskeen/widgets/spaces.dart';

import 'homeScreen.dart';

class customerScreen extends StatefulWidget {
  @override
  _customerScreenState createState() => _customerScreenState();
}

bool isAnimating = true;
enum ButtonState { init, submitting, completed }

class _customerScreenState extends State<customerScreen> {
  bool isSwitched = false;

  Future<void> _onItemTapped(int index) async {
    _selectedIndex = index;
    if (index < 5)
      if(index == 4) {
        scaffoldKey.currentState!.openEndDrawer(); // CHANGE THIS LINE
      }
      else{
        Navigator.pushReplacement(context,PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => _children[_selectedIndex],
        ));
      }
    if (firstsyncRequired == false && index != 2)
      setState(() {
        _selectedIndex = index;
      });
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ButtonState state = ButtonState.init;
  int _selectedIndex = 0;
  bool firstsyncRequired = false;
  final List<Widget> _children = [
    customerScreen(),
    homeScreen(),
    reportScreen()
  ];
  TextEditingController name=new TextEditingController(text: null);
  TextEditingController number=new TextEditingController(text: null);
  TextEditingController address=new TextEditingController(text: null);
  TextEditingController price=new TextEditingController(text: null);
  ParticleOptions particles = const ParticleOptions(
    baseColor: Colors.cyan,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 70,
    spawnMaxRadius: 15.0,
    spawnMaxSpeed: 100.0,
    spawnMinSpeed: 30,
    spawnMinRadius: 7.0,
  );

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width;
    final isInit = isAnimating || state == ButtonState.init;
    final isDone = state == ButtonState.completed;
    ThemeData theme = Theme.of(context);
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              ClipShadowPath(
                clipper: LoginDesign4ShapeClipper(),
                shadow: Shadow(blurRadius: 24, color: AppColors.blue),
                child: Container(
                  height: heightOfScreen * 0.4,
                  width: widthOfScreen,
                  color: AppColors.blue,
                  child: Container(
                    margin: EdgeInsets.only(left: Sizes.MARGIN_24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: heightOfScreen * 0.1,
                        ),
                        Text(
                          StringConst.SIGN_UP_3,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView(
                padding: EdgeInsets.all(Sizes.PADDING_0),
                children: <Widget>[
                  SizedBox(
                    height: heightOfScreen * 0.38,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Semantics(
                          label: "App Password",
                          child: TextField(
//inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),],
                              controller: name,
                              onChanged: (appPass) {
                                setState(() {
                                  appPass = appPass;
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                border: InputBorder.none,
                                hintText: "  Customer Name",
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Semantics(
                          label: "App Password",
                          child: TextField(
//inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),],
                              controller: number,
                              onChanged: (appPass) {
                                setState(() {
                                  appPass = appPass;
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                border: InputBorder.none,
                                hintText: "  Phone Number",
                              ),
                            keyboardType: TextInputType.number,
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Semantics(
                          label: "App Password",
                          child: TextField(
//inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),],
                              controller: address,
                              onChanged: (appPass) {
                                setState(() {
                                  appPass = appPass;
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                border: InputBorder.none,
                                hintText: "  Address",
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Semantics(
                          label: "App Password",
                          child: TextField(
//inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),],
                              controller: price,
                              onChanged: (appPass) {
                                setState(() {
                                  appPass = appPass;
                                });
                              },
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                FilteringTextInputFormatter.digitsOnly

                              ],
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                border: InputBorder.none,
                                hintText: "  Rate",
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(40),
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        onEnd: () => setState(() {
                          isAnimating = !isAnimating;
                        }),
                        width: state == ButtonState.init ? buttonWidth : 70,
                        height: 60,
// If Button State is Submiting or Completed  show 'buttonCircular' widget as below
                        child: isInit ? buildButton(context) : circularContainer(isDone)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 0,
              offset: const Offset(0, 0.1),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        margin: EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Container(
                  //padding: const EdgeInsets.all(7),
                    child: SvgPicture.asset(
                      "assets/compass.svg", fit: BoxFit.none,)
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  //padding: const EdgeInsets.all(7),
                    child: SvgPicture.asset(
                      "assets/home.svg", fit: BoxFit.none,)

                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  //padding: const EdgeInsets.all(7),
                    child: SvgPicture.asset(
                      "assets/mail.svg", fit: BoxFit.none,)
                ),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black.withOpacity(0.5),
            unselectedItemColor: Colors.black45,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
    onPressed: () async {
      if(name.text!=""||price.text!=""&&number.text!=""&&address.text!=""){
        final documentReference = usersRef.doc();
        final docId = documentReference.id;
        documentReference.set({
          'id': docId,
          'name':name.text,
          'number':number.text,
          'address':address.text,
          'price':price.text,
          'payment':'0',
          'returned':'0'
        });
        setState(() {
          state = ButtonState.submitting;
        });
        //await 2 sec // you need to implement your server response here.
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          state = ButtonState.completed;
        });
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          state = ButtonState.init;
        });
        Navigator.pushNamed(context, '/customerScreen');
      }
      else{
        showInSnackBar("Error",context);
      }
    },
    child: const Text('SUBMIT'),
  );

  Widget circularContainer(bool done) {
    final color = done ? Colors.green : Colors.blue;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: done
            ? const Icon(Icons.done, size: 50, color: Colors.white)
            : const CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value,textAlign: TextAlign.center,),
      ),
    );
  }
}
