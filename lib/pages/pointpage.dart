import 'package:brunelrecycleprototype/pages/addnewpoint.dart';
import 'package:brunelrecycleprototype/utlitis/constant.dart';
import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custombottomnavigatiorbar.dart';

class PointsPage extends StatefulWidget {
  static String id = 'pointspage';
  const PointsPage({Key? key}) : super(key: key);

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 3),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Points',
                style: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: hight * 0.04),
              StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('users').where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: 50,
                          child: CircularProgressIndicator(
                            color: kPrimeryColor,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Record not found',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                        );
                      } else {
                        Map<dynamic, dynamic> userMaterials = snapshot.data?.docs[0].get('materials');
                        userMaterials = Map.fromEntries(userMaterials.entries.toList()..sort((e2, e1) => e1.key.compareTo(e2.key)));
                        List userMaterialdatetime = userMaterials.keys.toList();
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TotalPointWidgets(
                                  title: 'Total Recycle',
                                  points: snapshot.data?.docs[0].get('recyclingNumber') ?? '0',
                                  increment: snapshot.data?.docs[0].get('currentRecyclingNumber') < snapshot.data?.docs[0].get('lastRecyclingNumber')
                                      ? ((snapshot.data?.docs[0].get('currentRecyclingNumber') as int) * -100) /
                                          (snapshot.data?.docs[0].get('lastRecyclingNumber') as int)
                                      : ((snapshot.data?.docs[0].get('lastRecyclingNumber') as int) * 100) /
                                          (snapshot.data?.docs[0].get('currentRecyclingNumber') as int),
                                  color: kPrimeryColor,
                                ),
                                SizedBox(width: width * 0.25),
                                TotalPointWidgets(
                                  title: 'Total Points',
                                  points: snapshot.data?.docs[0].get('points'),
                                  increment: snapshot.data?.docs[0].get('currentPoints') < snapshot.data?.docs[0].get('lastPoints')
                                      ? ((snapshot.data?.docs[0].get('currentPoints') as int) * -100) /
                                          (snapshot.data?.docs[0].get('lastPoints') as int)
                                      : ((snapshot.data?.docs[0].get('lastPoints') as int) * 100) /
                                          (snapshot.data?.docs[0].get('currentPoints') as int),
                                  color: kSecondaryColor,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Last Recycles',
                                  style: TextStyle(color: kGreyColor),
                                ),
                                IconButton(onPressed: () {}, icon: SizedBox(height: 27, child: Image.asset('assets/icons/icon_filter.png'))),
                              ],
                            ),
                            SizedBox(
                              height: hight * 0.45,
                              child: ListView(
                                children: List.generate(
                                    userMaterialdatetime.length,
                                    (index) => Container(
                                          height: 62,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: kGreyColor.withOpacity(0.1),
                                                    radius: 25,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(userMaterials[userMaterialdatetime[index]]['name']),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              userMaterials[userMaterialdatetime[index]]['points'] > 0
                                                                  ? Icons.arrow_drop_up
                                                                  : Icons.arrow_drop_down,
                                                              color: userMaterials[userMaterialdatetime[index]]['points'] > 0
                                                                  ? kPrimeryColor
                                                                  : kErrorColor,
                                                            ),
                                                            Text(
                                                              userMaterials[userMaterialdatetime[index]]['points'].toString(),
                                                              style: TextStyle(color: kPrimeryColor, fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: kGreyColor,
                                                  )),
                                            ],
                                          ),
                                        )),
                              ),
                            ),
                            SizedBox(
                              height: hight * 0.01,
                            ),
                            CustomButton(
                                width: width,
                                btnradius: 10,
                                text: 'Add Points',
                                onPress: () {
                                  Navigator.pushNamed(context, AddNewPoint.id);
                                }),
                          ],
                        );
                      }
                    } else {
                      return Text(
                        'Record not found',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      );
                    }
                  }),
              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         TotalPointWidgets(
              //           title: 'Total Recycle',
              //           points: '128',
              //           increment: 8.00,
              //           color: kPrimeryColor,
              //         ),
              //         SizedBox(width: width * 0.25),
              //         TotalPointWidgets(
              //           title: 'Total Points',
              //           points: '2350',
              //           increment: 2.34,
              //           color: kSecondaryColor,
              //         ),
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           'Last Recycles',
              //           style: TextStyle(color: kGreyColor),
              //         ),
              //         IconButton(onPressed: () {}, icon: SizedBox(height: 27, child: Image.asset('assets/icons/icon_filter.png'))),
              //       ],
              //     ),
              //     SizedBox(
              //       height: hight * 0.45,
              //       child: ListView(
              //         children: [
              //           Container(
              //             height: 62,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Row(
              //                   children: [
              //                     CircleAvatar(
              //                       backgroundColor: kGreyColor.withOpacity(0.1),
              //                       radius: 25,
              //                     ),
              //                     Container(
              //                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //                       child: Column(
              //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Text('Bottle'),
              //                           Row(
              //                             children: [
              //                               Icon(
              //                                 Icons.arrow_drop_up,
              //                                 color: kPrimeryColor,
              //                               ),
              //                               Text(
              //                                 '22',
              //                                 style: TextStyle(color: kPrimeryColor, fontSize: 12),
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 IconButton(
              //                     onPressed: () {},
              //                     icon: Icon(
              //                       Icons.arrow_forward_ios,
              //                       color: kGreyColor,
              //                     )),
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //     CustomButton(
              //         width: width,
              //         btnradius: 10,
              //         text: 'Add Points',
              //         onPress: () {
              //           Navigator.pushNamed(context, AddNewPoint.id);
              //         }),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalPointWidgets extends StatelessWidget {
  const TotalPointWidgets({
    super.key,
    required this.points,
    required this.title,
    required this.increment,
    required this.color,
  });
  final String title;
  final int points;
  final double increment;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: kGreyColor),
            ),
            SizedBox(height: 10),
            Text(points.toString(), style: TextStyle(color: kBlackColor, fontSize: 32, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: 114,
              height: 37,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kGreyColor.withOpacity(0.1)),
              child: increment == 0 || increment.isNaN
                  ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                          width: 20,
                          height: 25,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: color.withOpacity(0.8)),
                          child: Center(
                            child: Icon(Icons.remove, color: kWhiteColor, size: 10),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text('--', style: TextStyle(color: color)),
                          Text('.--', style: TextStyle(color: color)),
                          Text('%', style: TextStyle(color: color)),
                        ],
                      ),
                    ])
                  : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                          width: 20,
                          height: 25,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: color.withOpacity(0.8)),
                          child: Center(
                            child: Icon(increment > 0 ? Icons.arrow_upward : Icons.arrow_downward, color: kWhiteColor, size: 10),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(increment > 0 ? '+' : '', style: TextStyle(color: color)),
                          Text(increment.toStringAsFixed(2), style: TextStyle(color: color)),
                          Text('%', style: TextStyle(color: color)),
                        ],
                      ),
                    ]),
            ),
            SizedBox(height: 40),
          ],
        )
      ],
    );
  }
}
