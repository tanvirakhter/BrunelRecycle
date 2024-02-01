import 'dart:io';

import 'package:brunelrecycleprototype/pages/contactuspage.dart';
import 'package:brunelrecycleprototype/pages/editprofilepage.dart';
import 'package:brunelrecycleprototype/pages/helpandsupportpage.dart';
import 'package:brunelrecycleprototype/pages/loginpage.dart';
import 'package:brunelrecycleprototype/pages/privacypage.dart';
import 'package:brunelrecycleprototype/widgets/customsnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';

class ProfilePage extends StatefulWidget {
  static String id = 'ProfilePage';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 4),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
        child: ListView(
          shrinkWrap: true,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return UserProfile(
                      width: width,
                      hight: hight,
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      print('pass');
                      return UserProfile(
                        width: width,
                        hight: hight,
                      );
                    } else {
                      // check2.add(1);
                      return UserProfile(
                        width: width,
                        hight: hight,
                        image: snapshot.data?.docs[0].get('imagelocation'),
                        uni: snapshot.data?.docs[0].get('uni'),
                        name: snapshot.data?.docs[0].get('fullname'),
                        points: snapshot.data?.docs[0].get('points'),
                        dept: snapshot.data?.docs[0].get('dept'),
                      );
                    }
                  } else {
                    return UserProfile(
                      width: width,
                      hight: hight,
                    );
                  }
                }),
            SizedBox(height: hight * 0.08),
            Container(
              width: width * 0.7,
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  ProfileButton(
                      text: 'Edit Profile Information',
                      icon: 'assets/icons/EditProfile.png',
                      onTap: () {
                        Navigator.pushNamed(context, EditProfilePage.id);
                      }),
                  SizedBox(height: hight * 0.05),
                  ProfileButton(
                      text: 'Help & Support',
                      icon: 'assets/icons/help.png',
                      onTap: () {
                        Navigator.pushNamed(context, HelpSupportPage.id);
                      }),
                  SizedBox(height: hight * 0.05),
                  ProfileButton(
                      text: 'Contact us',
                      icon: 'assets/icons/communication.png',
                      onTap: () {
                        Navigator.pushNamed(context, ContactUsPage.id);
                      }),
                  SizedBox(height: hight * 0.05),
                  ProfileButton(
                      text: 'Privacy policy',
                      icon: 'assets/icons/lock.png',
                      onTap: () {
                        Navigator.pushNamed(context, PrivacyPage.id);
                      }),
                  SizedBox(height: hight * 0.05),
                  ProfileButton(
                      text: 'Logout',
                      icon: 'assets/icons/logout.png',
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        showSnackBar(context, 'User Signed Out');
                        Navigator.pushReplacementNamed(context, LoginPage.id);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });
  final String icon;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ImageIcon(AssetImage(icon)), SizedBox(width: 10), Text(text)],
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
    required this.width,
    required this.hight,
    this.image: '',
    this.name: 'Loading',
    this.dept: 'Loading',
    this.points: 0,
    this.uni: 'Loading',
  });

  final double width;
  final double hight;
  final String image;
  final String name;
  final int points;
  final String dept;
  final String uni;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        image != ''
            ? CircleAvatar(
                backgroundColor: kSecondaryColor,
                backgroundImage: NetworkImage(image),
                radius: width * 0.2,
                // child: image != '' ? Image.network(image) : Text('No Image found'),
              )
            : CircleAvatar(
                backgroundColor: kSecondaryColor,
                radius: width * 0.2,
                child: Text('No Image found'),
              ),
        SizedBox(height: hight * 0.02),
        Text(name, style: TextStyle(color: kBlackColor, fontSize: 22, fontWeight: FontWeight.w600)),
        SizedBox(height: hight * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Points: ', style: TextStyle(color: kBlackColor, fontSize: 14, fontWeight: FontWeight.w400)),
            Text(points.toString(), style: TextStyle(color: kBlackColor, fontSize: 14, fontWeight: FontWeight.w400)),
          ],
        ),
        SizedBox(height: hight * 0.001),
        Text(dept, style: TextStyle(color: kBlackColor, fontSize: 14, fontWeight: FontWeight.w400)),
        SizedBox(height: hight * 0.001),
        Text(uni, style: TextStyle(color: kBlackColor, fontSize: 14, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
