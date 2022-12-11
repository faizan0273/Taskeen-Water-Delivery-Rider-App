import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskeen/Models/userModel.dart';
import 'package:taskeen/reportScreen.dart';
import 'package:taskeen/utils/firebase.dart';
import 'package:taskeen/values/values.dart';
import 'package:taskeen/widgets/clipShadowPath.dart';
import 'package:taskeen/widgets/custom_shape_clippers.dart';
import 'Models/deliveryModel.dart';
import 'customerScreen.dart';
import 'homeScreen.dart';

class viewScreen extends StatefulWidget {
  final String profileId;
  viewScreen({required this.profileId});
  @override
  _viewScreenState createState() => _viewScreenState();
}

class _viewScreenState extends State<viewScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    initialize();
  }
  TextEditingController name=new TextEditingController();
  TextEditingController address=new TextEditingController();
  TextEditingController price=new TextEditingController();
  TextEditingController number=new TextEditingController();
  TextEditingController total=new TextEditingController();
  TextEditingController paid=new TextEditingController();
  TextEditingController pending=new TextEditingController();
  TextEditingController delivered=new TextEditingController();
  TextEditingController returned=new TextEditingController();
  UserModel user=UserModel(name: '',number: '',address: '',payment: '',price: '',id: '');
  initialize()async{
    DocumentSnapshot doc = await usersRef!.doc(widget.profileId).get();
    user = UserModel.fromJson((doc?.data()??{}) as Map<String, dynamic>);
    setState(() {
    });
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
            child: Column(
              children: <Widget>[
                // ClipShadowPath(
                //   clipper: LoginDesign4ShapeClipper(),
                //   shadow: Shadow(blurRadius: 24, color: AppColors.blue),
                //   child: Container(
                //     height: heightOfScreen * 0.4,
                //     width: widthOfScreen,
                //     color: AppColors.blue,
                //     child: Container(
                //       margin: EdgeInsets.only(left: Sizes.MARGIN_24),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           SizedBox(
                //             height: heightOfScreen * 0.1,
                //           ),
                //           Text(
                //             StringConst.HELLO_2,
                //             style: theme.textTheme.headlineSmall?.copyWith(
                //               fontSize: Sizes.TEXT_SIZE_20,
                //               color: AppColors.white,
                //             ),
                //           ),
                //           Text(
                //             "REPORT!",
                //             style: theme.textTheme.headlineLarge?.copyWith(
                //               color: AppColors.white,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  height: 130,
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child:Text("    Name:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800,),),
                            ),
                            Expanded(
                              child:Text("    ${user.name}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(
                              child:Text("    Address:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800,),),
                            ),
                            Expanded(
                              child:Text("    ${user.address}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(
                              child:Text("    Contact:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800,),),
                            ),
                            Expanded(
                              child:Text("    ${user.number}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(
                              child:Text("    Price:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800,),),
                            ),
                            Expanded(
                              child:Text("    ${user.price}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit'),
                                    content: Column(
                                      children: <Widget>[
                                        TextField(
                                            onChanged: (appPass) {
                                              setState(() {
                                                name.text = appPass;
                                                address.text=user.address.toString();
                                                number.text=user.number.toString();
                                                price.text=user.price.toString();
                                              });
                                            },
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: "Name",
                                              hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                              border: InputBorder.none,
                                              hintText: "  ${user.name}",
                                            )
                                        ),
                                        TextField(
                                            onChanged: (appPass) {
                                              setState(() {
                                                address.text = appPass;
                                                name.text=user.name.toString();
                                                number.text=user.number.toString();
                                                price.text=user.price.toString();
                                              });
                                            },
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: "Address",
                                              hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                              border: InputBorder.none,
                                              hintText: "  ${user.address}",
                                            )
                                        ),
                                        TextField(
                                            onChanged: (appPass) {
                                              setState(() {
                                                number.text = appPass;
                                                address.text=user.address.toString();
                                                name.text=user.name.toString();
                                                price.text=user.price.toString();
                                              });
                                            },
                                            inputFormatters: <TextInputFormatter>[
                                              // for below version 2 use this
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly

                                            ],
                                            keyboardType: TextInputType.number,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: "Number",
                                              hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                              border: InputBorder.none,
                                              hintText: "  ${user.number}",
                                            )
                                        ),
                                        TextField(
                                            onChanged: (appPass) {
                                              setState(() {
                                                price.text = appPass;
                                                address.text=user.address.toString();
                                                number.text=user.number.toString();
                                                name.text=user.name.toString();
                                              });
                                            },
                                            inputFormatters: <TextInputFormatter>[
                                              // for below version 2 use this
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly

                                            ],
                                            keyboardType: TextInputType.number,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: "Price",
                                              hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                              border: InputBorder.none,
                                              hintText: "  ${user.price}",
                                            )
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Confirm'),
                                        onPressed: () {
                                          print("User Id");
                                          print(user.id);
                                          usersRef.doc(user.id).update({'address': address.text.toString()});
                                          usersRef.doc(user.id).update({'name': name.text.toString()});
                                          usersRef.doc(user.id).update({'number': number.text.toString()});
                                          usersRef.doc(user.id).update({'price': price.text.toString()});
                                          print('Confirmed');
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('EDIT INFO'),
                            style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                          ),
                        ),
                      ],
                    )
                  )
                ),
                SizedBox(height: 10,),
                Flexible(child: ListView(
                  padding: EdgeInsets.all(Sizes.PADDING_0),
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<DeliveryModel>>(
                          future:getallUsers(),
                          builder: (context, AsyncSnapshot<List<DeliveryModel>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    print(snapshot.data![index].id);
                                    return Card(
                                      child: ExpansionTile(
                                        title: Row(
                                          children: [
                                            Expanded(child: Text(
                                              "${snapshot.data![index].date}",
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900,),
                                            ),),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false, // user must tap button!
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Edit'),
                                                        content: Column(
                                                          children: <Widget>[
                                                            TextField(
                                                                onChanged: (appPass) {
                                                                  setState(() {
                                                                    total.text = appPass;
                                                                    delivered.text=snapshot.data![index].quantity.toString();
                                                                    paid.text=snapshot.data![index].paid.toString();
                                                                    pending.text=snapshot.data![index].pending.toString();
                                                                    returned.text=snapshot.data![index].returned.toString();
                                                                  });
                                                                },
                                                                inputFormatters: <TextInputFormatter>[
                                                                  // for below version 2 use this
                                                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly

                                                                ],
                                                                keyboardType: TextInputType.number,
                                                                obscureText: false,
                                                                decoration: InputDecoration(
                                                                  labelText: "Total",
                                                                  hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                                                  border: InputBorder.none,
                                                                  hintText: "  ${snapshot.data![index].total}",
                                                                )
                                                            ),
                                                            TextField(
                                                                onChanged: (appPass) {
                                                                  setState(() {
                                                                    paid.text = appPass;
                                                                    total.text=snapshot.data![index].total.toString();
                                                                    delivered.text=snapshot.data![index].quantity.toString();
                                                                    pending.text=snapshot.data![index].pending.toString();
                                                                    returned.text=snapshot.data![index].returned.toString();
                                                                  });
                                                                },
                                                                inputFormatters: <TextInputFormatter>[
                                                                  // for below version 2 use this
                                                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly

                                                                ],
                                                                keyboardType: TextInputType.number,
                                                                obscureText: false,
                                                                decoration: InputDecoration(
                                                                  labelText: "Paid",
                                                                  hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                                                  border: InputBorder.none,
                                                                  hintText: "  ${snapshot.data![index].paid}",
                                                                )
                                                            ),
                                                            TextField(
                                                                onChanged: (appPass) {
                                                                  setState(() {
                                                                    pending.text = appPass;
                                                                    total.text=snapshot.data![index].total.toString();
                                                                    paid.text=snapshot.data![index].paid.toString();
                                                                    delivered.text=snapshot.data![index].quantity.toString();
                                                                    returned.text=snapshot.data![index].returned.toString();
                                                                  });
                                                                },
                                                                inputFormatters: <TextInputFormatter>[
                                                                  // for below version 2 use this
                                                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly

                                                                ],
                                                                keyboardType: TextInputType.number,
                                                                obscureText: false,
                                                                decoration: InputDecoration(
                                                                  labelText: "Pending",
                                                                  hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                                                  border: InputBorder.none,
                                                                  hintText: "  ${snapshot.data![index].pending}",
                                                                )
                                                            ),
                                                            TextField(
                                                                onChanged: (appPass) {
                                                                  setState(() {
                                                                    delivered.text = appPass;
                                                                    total.text=snapshot.data![index].total.toString();
                                                                    paid.text=snapshot.data![index].paid.toString();
                                                                    pending.text=snapshot.data![index].pending.toString();
                                                                    returned.text=snapshot.data![index].returned.toString();
                                                                  });
                                                                },
                                                                inputFormatters: <TextInputFormatter>[
                                                                  // for below version 2 use this
                                                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly

                                                                ],
                                                                keyboardType: TextInputType.number,
                                                                obscureText: false,
                                                                decoration: InputDecoration(
                                                                  labelText: "Quantity",
                                                                  hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                                                  border: InputBorder.none,
                                                                  hintText: "  ${snapshot.data![index].quantity}",
                                                                )
                                                            ),
                                                            TextField(
                                                                onChanged: (appPass) {
                                                                  setState(() {
                                                                    returned.text = appPass;
                                                                    total.text=snapshot.data![index].total.toString();
                                                                    paid.text=snapshot.data![index].paid.toString();
                                                                    pending.text=snapshot.data![index].pending.toString();
                                                                    delivered.text=snapshot.data![index].quantity.toString();

                                                                  });
                                                                },
                                                                inputFormatters: <TextInputFormatter>[
                                                                  // for below version 2 use this
                                                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly

                                                                ],
                                                                keyboardType: TextInputType.number,
                                                                obscureText: false,
                                                                decoration: InputDecoration(
                                                                  labelText: "Returned",
                                                                  hintStyle: TextStyle(fontFamily: 'Gilroy'),
                                                                  border: InputBorder.none,
                                                                  hintText: "  ${snapshot.data![index].returned}",
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('Confirm'),
                                                            onPressed: () {
                                                              deliveriesRef.doc(snapshot.data![index].id).update({'paid': paid.text.toString()});
                                                              deliveriesRef.doc(snapshot.data![index].id).update({'pending': pending.text.toString()});
                                                              deliveriesRef.doc(snapshot.data![index].id).update({'quantity': delivered.text.toString()});
                                                              deliveriesRef.doc(snapshot.data![index].id).update({'returned': returned.text.toString()});
                                                              deliveriesRef.doc(snapshot.data![index].id).update({'total': total.text.toString()});
                                                              print('Confirmed');
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text('Cancel'),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text('EDIT'),
                                                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                                              ),
                                            ),
                                            // Expanded(child: CircleAvatar(
                                            //   backgroundColor: int.parse(snapshot.data![index].quantity.toString())<=int.parse(snapshot.data![index].returned.toString())?Colors.blue:Colors.red,
                                            //   child: Text("${snapshot.data![index].quantity}"),
                                            //   maxRadius: 20,
                                            // ),),
                                          ],
                                        ),
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child:Text("    Total:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    ${snapshot.data![index].total}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    Paid:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    ${snapshot.data![index].paid}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Expanded(
                                                child:Text("    Pending:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    ${snapshot.data![index].pending}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    Quantity:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    ${snapshot.data![index].quantity}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Expanded(
                                                child:Text("    Returned:",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    ${snapshot.data![index].returned}",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    ",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                              Expanded(
                                                child:Text("    ",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,),),
                                              ),
                                            ],
                                          ),
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
                )),

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

  Future<List<DeliveryModel>> getallUsers()async{

    List<DeliveryModel> allUserList = [];
    await deliveriesRef.where('id', isEqualTo: widget.profileId)
        .get()
        .then((qSnap) {
      if (qSnap.docs.length > 0) {
        allUserList.clear();
        qSnap.docs.forEach((element) {
          //* in future we can also remove friend whom already request sent
          allUserList.add(DeliveryModel.fromDocumentSnapshot(element));
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