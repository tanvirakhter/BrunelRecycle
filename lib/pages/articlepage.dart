import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';
import 'package:intl/intl.dart';

class ArticlePage extends StatelessWidget {
  static String id = 'ArticlePage';
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 1),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Article', style: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: hight * 0.02),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('article').orderBy('datetime', descending: true).snapshots(),
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
                        return SizedBox(
                          height: hight * 0.7,
                          child: ListView(
                            children: List.generate(snapshot.data?.docs.length ?? 0, (index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data?.docs[index].get('title'),
                                      style: TextStyle(color: kBlackColor, fontSize: 16, fontWeight: FontWeight.w400)),
                                  SizedBox(height: hight * 0.02),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 220,
                                    child: Image.network(snapshot.data?.docs[index].get('imagelocation'), fit: BoxFit.fill),
                                  ),
                                  SizedBox(height: hight * 0.02),
                                  Text(
                                      DateTime.now().difference((snapshot.data?.docs[0].get('datetime') as Timestamp).toDate()).inMinutes < 60
                                          ? '${DateTime.now().difference((snapshot.data?.docs[0].get('datetime') as Timestamp).toDate()).inMinutes.toString()} Minutes ago'
                                          : DateTime.now().difference((snapshot.data?.docs[0].get('datetime') as Timestamp).toDate()).inHours < 24
                                              ? '${DateTime.now().difference((snapshot.data?.docs[0].get('datetime') as Timestamp).toDate()).inHours.toString()} hours ago'
                                              : DateFormat('yyyy-MM-dd')
                                                  .format((snapshot.data?.docs[0].get('datetime') as Timestamp).toDate())
                                                  .toString(),
                                      style: TextStyle(color: kGreyColor, fontSize: 12, fontWeight: FontWeight.w400)),
                                  SizedBox(height: hight * 0.02),
                                  Text(
                                    '${snapshot.data?.docs[index].get('para1')} \n\n ${snapshot.data?.docs[index].get('para2')}',
                                    style: TextStyle(color: kBlackColor, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1.5),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              );
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
