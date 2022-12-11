import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskeen/customerScreen.dart';
import 'package:taskeen/reportScreen.dart';
import 'package:taskeen/temp.dart';
import 'package:taskeen/utils/firebase.dart';
import 'package:taskeen/values/values.dart';
import 'package:taskeen/widgets/clipShadowPath.dart';
import 'package:taskeen/widgets/custom_shape_clippers.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Models/userModel.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);
  @override
  _homeScreenState createState() => _homeScreenState();
}
bool isAnimating = true;
enum ButtonState { init, submitting, completed }

class _homeScreenState extends State<homeScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  Widget _submitButton() {
    return InkWell(
      onTap: ()async{
        Navigator.pushNamed(context, '/startUpScreen');
      },
      child: Container(
        width: 155,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,)
          ],
        ),
        child: Text(
          'Share Your Version',
          style: TextStyle(color: Colors.white,fontFamily: 'Gilroy' ),
        ),
      ),
    );
  }
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
  TextEditingController quantity_=new TextEditingController();
  TextEditingController payment_=new TextEditingController();
  TextEditingController returned_=new TextEditingController();
  String? rate='Rate',id=' ',name='Select Customer';
  int quantity=0,payment=0,pending=0,returned=0;
  bool plus=false;
  bool pause = true;
  String? selectedValue;
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
                          "DELIVER!",
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 13),
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                ),
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return DraggableScrollableSheet(
                                            expand: false,
                                            builder: (BuildContext context, ScrollController scrollController) {
                                              return Column(children: <Widget>[
                                                Expanded(
                                                  child: StreamBuilder(
                                                    stream: usersRef.snapshots(),
                                                    builder: (context,
                                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                                      if (snapshot.hasData) {
                                                        List<DocumentSnapshot> docs = snapshot.data!.docs as List<DocumentSnapshot<Object?>>;
                                                        return ListView.builder(
                                                            itemCount: docs.length,
                                                            itemBuilder: (BuildContext context, int index){
                                                              return FutureBuilder(
                                                                  future: getUsers(docs[index].id),
                                                                  builder: (context, AsyncSnapshot<UserModel> snapshot){
                                                                    return InkWell(
                                                                      onTap: ()async{
                                                                        setState(() {
                                                                          rate=snapshot.data!.price;
                                                                          name=snapshot.data!.name;
                                                                          returned=int.parse(snapshot.data!.returned.toString());
                                                                          id=snapshot.data!.id.toString();
                                                                          pending=int.parse(snapshot.data!.payment.toString());
                                                                        });
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1),
                                                                        child: Card(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: snapshot.data!=null?Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text("${snapshot.data!.name}",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                                                                Text("(${snapshot.data!.address})",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w300),),
                                                                                Text("(${snapshot.data!.number})",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w300),)
                                                                              ],
                                                                            ):Container(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            });
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                )
                                              ]);
                                            }
                                        );
                                      }
                                  );
                                }
                            );
                          },
                          child: Text('${name}'),
                          style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 13),
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 1,
                                  offset: const Offset(0,0.2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Semantics(
                                  label: "App Password",
                                  child: TextField(
                                    textAlign: TextAlign.center,
//inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),],
                                      readOnly: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontFamily: 'Gilroy',fontSize: 12),
                                        border: InputBorder.none,
                                        hintText:'${rate}',
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),),
                          Expanded(child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 13),
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 1,
                                  offset: const Offset(0,0.2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Semantics(
                                  label: "App Password",
                                  child: TextField(
                                      textAlign: TextAlign.center,
//inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),],
                                      controller: quantity_,
                                      onChanged: (appPass){
                                        setState(() {
                                          if(appPass==0){
                                            quantity=0;
                                            payment=0;
                                          }else{
                                            quantity=int.parse(appPass);
                                            payment=(quantity*int.parse(rate!));
                                          }
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
// for below version 2 use this
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                        FilteringTextInputFormatter.digitsOnly

                                      ],
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontFamily: 'Gilroy',fontSize: 12),
                                        border: InputBorder.none,
                                        hintText:" Delivered",
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),),
                          Expanded(child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 13),
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 1,
                                  offset: const Offset(0,0.2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Semantics(
                                  label: "App Password",
                                  child: TextField(
                                      textAlign: TextAlign.center,
//inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),],
                                      controller: payment_,
                                      onChanged: (appPass){
                                        setState(() {
                                          payment=int.parse(appPass);
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
// for below version 2 use this
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                        FilteringTextInputFormatter.digitsOnly

                                      ],
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontFamily: 'Gilroy',fontSize: 12),
                                        border: InputBorder.none,
                                        hintText:payment==0?" Payment":"${payment}",
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),),
                          Expanded(child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 13),
                            decoration:BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 1,
                                  offset: const Offset(0,0.2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Semantics(
                                  label: "App Password",
                                  child: TextField(
                                      textAlign: TextAlign.center,
                                    controller: returned_,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontFamily: 'Gilroy',fontSize: 12),
                                        border: InputBorder.none,
                                        hintText:'Returned',
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),),
                        ],
                      ),
                      // SizedBox(height: 20,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text("PENDING:${pending}",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.red,fontSize: 40),)
                      //   ],
                      // ),
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
                            child: isInit ? buildButton() : circularContainer(isDone)),
                      ),
                    ],
                  )
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

  Future<UserModel> getUsers(String id)async{
    UserModel allUserList = UserModel();
    await usersRef
        .doc(id).get()
        .then((qSnap) {
      allUserList= UserModel.fromDocumentSnapshot(qSnap);
    });
    return allUserList ;
  }

  Widget buildButton() => ElevatedButton(
    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
    onPressed: () async {
        int a=int.parse(quantity_.text);
        int b=int.parse(rate!);
        int c=a*b;
        a=c-payment+pending;
        int z=int.parse(returned_.text.toString());
        if(z<returned){
          z=z-returned;
        }
        usersRef.doc(id).update({'payment': a.toString()});
        usersRef.doc(id).update({'returned': z.toString()});
        final DateTime now = DateTime.now();
        final DateFormat format = DateFormat('dd-MM-yyyy hh:mm:ss');
        final String formatted = format.format(now);
        Map<String, dynamic> someData = {
          'id': id,
          'name':name,
          'quantity':quantity_.text,
          'total':(c+pending).toString(),
          'paid':payment.toString(),
          'pending':a.toString(),
          'date':'${formatted}',
          'returned':'${returned_.text}',
          "doc": ''
        };
        DocumentReference doc_re=deliveriesRef.doc().set(someData).toString() as DocumentReference<Object?>;
        deliveriesRef.doc(doc_re.id).update({'doc': "${doc_re.id}"});
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
        quantity_.clear();
        payment_.clear();
        rate='Rate';
        Navigator.pushNamed(context, '/homeScreen');
    },
    child: const Text('Delivered'),
  );
  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value,textAlign: TextAlign.center,),
      ),
    );
  }
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
}