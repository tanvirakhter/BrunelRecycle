import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';

class LeaderBoardPage extends StatelessWidget {
  static String id = 'LeaderBoardPage';
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 0),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: ListView(
            children: [
              Text('Leaderboard', style: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: hight * 0.02),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').orderBy('points', descending: true).snapshots(),
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
                        // check2.add(1);
                        return SizedBox(
                          height: hight * 0.8,
                          child: ListView(
                            children: List.generate(snapshot.data!.docs.length, (index) {
                              return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            index == 0
                                                ? SizedBox(width: 25, height: 35, child: Image.asset('assets/icons/trophy1.png'))
                                                : index == 1
                                                    ? SizedBox(width: 25, height: 35, child: Image.asset('assets/icons/trophy2.png'))
                                                    : index == 2
                                                        ? SizedBox(width: 25, height: 35, child: Image.asset('assets/icons/trophy3.png'))
                                                        : CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor: kGreyColor.withOpacity(0.2),
                                                            child: Text(
                                                              index.toString(),
                                                              style: TextStyle(color: kGreyColor),
                                                            ),
                                                          ),
                                            SizedBox(width: 10),
                                            snapshot.data!.docs[index].get('imagelocation') == ''
                                                ? CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: kSecondaryColor,
                                                  )
                                                : CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage(snapshot.data!.docs[index].get('imagelocation')),
                                                  ),
                                            SizedBox(width: 10),
                                            Text(snapshot.data!.docs[index].get('fullname'),
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                                          ],
                                        ),
                                        Text(snapshot.data!.docs[index].get('points').toString(),
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  ));
                            }),
                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
