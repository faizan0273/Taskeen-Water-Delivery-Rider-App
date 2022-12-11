import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskeen/Models/userModel.dart';
import 'package:taskeen/utils/firebase.dart';
import 'package:taskeen/values/values.dart';
import 'package:taskeen/viewScreen.dart';
import 'package:taskeen/widgets/clipShadowPath.dart';
import 'package:taskeen/widgets/custom_shape_clippers.dart';
import 'Models/deliveryModel.dart';
import 'customerScreen.dart';
import 'homeScreen.dart';

class reportScreen extends StatefulWidget {

  const reportScreen({Key? key}) : super(key: key);
  @override
  _reportScreenState createState() => _reportScreenState();
}

class _reportScreenState extends State<reportScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    //initialize();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
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
  int _selectedIndex = 0;
  bool firstsyncRequired = false;
  final List<Widget> _children = [
    customerScreen(),
    homeScreen(),
    reportScreen()
  ];
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
    ThemeData theme = Theme.of(context);
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    return SafeArea(
      child:Scaffold(
        key: scaffoldKey,
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
                            "REPORT!",
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
                        FutureBuilder<List<UserModel>>(
                          future:getallUsers(),
                          builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Card(

                                      child: ExpansionTile(
                                        title: Row(
                                          children: [
                                            Expanded(child: Text(
                                              "${snapshot.data![index].address}",
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900,),
                                            ),),
                                            Expanded(
                                              child: Text("${snapshot.data![index].payment}",style: TextStyle(fontSize: 20,color: int.parse(snapshot.data![index].payment.toString())>=0?Colors.red:Colors.green,fontWeight: FontWeight.w900),),
                                            //   CircleAvatar(
                                            //   backgroundColor: int.parse(snapshot.data![index].payment.toString())>=0?Colors.red:Colors.green,
                                            //   child: Text("${snapshot.data![index].payment}",style: TextStyle(color: Colors.white),),
                                            //   maxRadius: 20,
                                            // ),
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child:Text("  ( ${snapshot.data![index].name} )",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewScreen(profileId: snapshot.data![index].id.toString(),)));
                                                  },
                                                  child: Text('All Orders'),
                                                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                        ],
                                      ),
                                    );
                                  });
                            } else
                              return Center(
                                child: Text('No Report Found',textAlign: TextAlign.center,),
                              );
                          },
                        )
                      ],
                    )
                  ],
                )

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
                offset: const Offset(0,0.1),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          margin: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Container(
                    //padding: const EdgeInsets.all(7),
                      child:SvgPicture.asset("assets/compass.svg",fit: BoxFit.none,)
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    //padding: const EdgeInsets.all(7),
                      child:SvgPicture.asset("assets/home.svg",fit: BoxFit.none,)

                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    //padding: const EdgeInsets.all(7),
                      child:SvgPicture.asset("assets/mail.svg",fit: BoxFit.none,)
                  ),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor:  Colors.black.withOpacity(0.5),
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
      ),
    );
  }

  Future<List<UserModel>> getallUsers()async{

    List<UserModel> allUserList = [];
    await usersRef
        .get()
        .then((qSnap) {
      if (qSnap.docs.length > 0) {
        allUserList.clear();
        qSnap.docs.forEach((element) {
          //* in future we can also remove friend whom already request sent
          allUserList.add(UserModel.fromDocumentSnapshot(element));
        });
      }
    });
    return allUserList ;
  }

}



Future<DeliveryModel> getUsers(String id)async{
  DeliveryModel allUserList = DeliveryModel();
  await deliveriesRef
      .doc(id).get()
      .then((qSnap) {
    allUserList= DeliveryModel.fromDocumentSnapshot(qSnap);
  });
  return allUserList ;
}

Future<UserModel> getUser(String id)async{
  UserModel allUserList = UserModel();
  await usersRef
      .doc(id).get()
      .then((qSnap) {
    allUserList= UserModel.fromDocumentSnapshot(qSnap);
  });
  return allUserList ;
}