import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:brunelrecycleprototype/widgets/customsnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';

class RewardPage extends StatefulWidget {
  static String id = 'RewardPage';
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  Map userMaterials = {};
  List<int> selectedItem = [];
  List<int> rewardPoints = [];
  List rewardsItem = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 2),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: ListView(
            children: [
              Text('Rewards', style: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: hight * 0.02),
              SizedBox(
                width: double.infinity,
                height: hight * 0.7,
                child: ListView(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('rewards').orderBy('datetime').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: kPrimeryColor,
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
                              return Wrap(
                                  runSpacing: 20,
                                  children: List.generate(
                                    snapshot.data!.docs.length,
                                    (index) => ProductCard(
                                      width: width,
                                      hight: hight,
                                      image: snapshot.data!.docs[index].get('imagelocation'),
                                      title: snapshot.data!.docs[index].get('name'),
                                      property: snapshot.data!.docs[index].get('property'),
                                      points: snapshot.data!.docs[index].get('points').toString(),
                                      selectedList: selectedItem,
                                      index: index,
                                      rewardPoints: rewardPoints,
                                      rewardsItem: rewardsItem,
                                    ),
                                  ));
                            }
                          } else {
                            return Text(
                              'Record not found',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                            );
                          }
                        }),
                    // Wrap(
                    //   runSpacing: 20,
                    //   children: [
                    //     ProductCard(
                    //         width: width,
                    //         hight: hight,
                    //         image: 'assets/images/bottle.png',
                    //         title: 'Water Bottle',
                    //         property: '500 .ml',
                    //         points: '1000',
                    //         addTap: () {}),
                    //     ProductCard(
                    //         width: width,
                    //         hight: hight,
                    //         image: 'assets/images/bottle.png',
                    //         title: 'Water Bottle',
                    //         property: '500 .ml',
                    //         points: '1000',
                    //         addTap: () {}),
                    //     ProductCard(
                    //         width: width,
                    //         hight: hight,
                    //         image: 'assets/images/bottle.png',
                    //         title: 'Water Bottle',
                    //         property: '500 .ml',
                    //         points: '1000',
                    //         addTap: () {}),
                    //     ProductCard(
                    //         width: width,
                    //         hight: hight,
                    //         image: 'assets/images/bottle.png',
                    //         title: 'Water Bottle',
                    //         property: '500 .ml',
                    //         points: '1000',
                    //         addTap: () {}),
                    //     ProductCard(
                    //         width: width,
                    //         hight: hight,
                    //         image: 'assets/images/bottle.png',
                    //         title: 'Water Bottle',
                    //         property: '500 .ml',
                    //         points: '1000',
                    //         addTap: () {}),
                    //     ProductCard(
                    //         width: width,
                    //         hight: hight,
                    //         image: 'assets/images/bottle.png',
                    //         title: 'Water Bottle',
                    //         property: '500 .ml',
                    //         points: '1000',
                    //         addTap: () {}),
                    //     ProductCard(
                    //         width: width,
                    //         hight: hight,
                    //         image: 'assets/images/bottle.png',
                    //         title: 'Water Bottle',
                    //         property: '500 .ml',
                    //         points: '1000',
                    //         addTap: () {}),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(height: hight * 0.01),
              CustomButton(
                  width: width,
                  text: 'CLAIM',
                  btnradius: 10,
                  onPress: () async {
                    try {
                      if (selectedItem.length <= 0) {
                        showSnackBar(context, 'Please Select The Reward');
                      } else {
                        int totalreward = 0;
                        for (int i = 0; i < rewardPoints.length; i++) {
                          totalreward = totalreward + rewardPoints[i];
                        }
                        ;
                        int userPoints = 0;
                        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                          userPoints = value.get('points') as int;
                          userMaterials = value.get('materials');
                        });
                        if (userPoints < totalreward) {
                          showSnackBar(context, 'You don\'t have enough points');
                        } else {
                          userMaterials[DateTime.now().toString()] = <String, dynamic>{
                            'name': 'Reward Claimed',
                            'points': -1 * totalreward,
                            'items': rewardsItem,
                          };
                          userPoints = userPoints - totalreward;
                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                            'materials': userMaterials,
                            'points': userPoints,
                          }).then((value) {
                            showSnackBar(context, 'Reward Claimed');
                            Navigator.pop(context);
                          });
                        }
                      }
                    } on FirebaseException catch (e) {
                      showSnackBar(context, e.message.toString());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  ProductCard({
    super.key,
    required this.width,
    required this.hight,
    required this.title,
    required this.points,
    required this.image,
    required this.property,
    required this.selectedList,
    required this.index,
    required this.rewardPoints,
    required this.rewardsItem,
  });

  final double width;
  final double hight;
  final String image;
  final String title;
  final String property;
  final String points;
  final int index;
  List<int> selectedList;
  List<int> rewardPoints;
  List rewardsItem;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: widget.width * 0.4,
                height: widget.hight * 0.25,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: widget.hight * 0.02),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: TextStyle(color: kBlackColor, fontSize: 11, fontWeight: FontWeight.w600)),
                      SizedBox(height: widget.hight * 0.002),
                      Text(widget.property, style: TextStyle(color: kBlackColor, fontSize: 11, fontWeight: FontWeight.w600)),
                      SizedBox(height: widget.hight * 0.002),
                      Text(widget.points, style: TextStyle(color: kBlackColor, fontSize: 11, fontWeight: FontWeight.w600)),
                      Text('points', style: TextStyle(color: kBlackColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(
                    width: widget.width * 0.06,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (!widget.selectedList.contains(widget.index)) {
                          widget.selectedList.add(widget.index);
                          widget.rewardPoints.add(int.parse(widget.points));
                          widget.rewardsItem.add({
                            'name': widget.title,
                            'point': widget.points,
                            'property': widget.property,
                            'imagelocation': widget.image,
                          });
                          selected = true;
                        } else {
                          widget.selectedList.remove(widget.index);

                          for (int i = 0; i < widget.rewardPoints.length; i++) {
                            if (widget.rewardPoints[i] == int.parse(widget.points)) {
                              widget.rewardPoints.removeAt(i);
                              break;
                            }
                          }
                          for (int i = 0; i < widget.rewardsItem.length; i++) {
                            if (widget.rewardsItem[i]['name'] == widget.title) {
                              widget.rewardsItem.removeAt(i);
                              break;
                            }
                          }
                          selected = false;
                        }
                        setState(() {});
                      },
                      child: CircleAvatar(
                          radius: 13, backgroundColor: kPrimeryColor, child: selected ? Icon(Icons.check, size: 20) : Icon(Icons.add, size: 20))),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
