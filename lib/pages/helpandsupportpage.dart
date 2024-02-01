import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:brunelrecycleprototype/widgets/customsnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';

class HelpSupportPage extends StatefulWidget {
  static String id = 'HelpSupportPage';
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 4),
      body: Container(
        padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Help and Support', style: TextStyle(fontSize: 20, color: kBlackColor, fontWeight: FontWeight.w600)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/icons/BackArrow.png')),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: msgController,
                  decoration: InputDecoration(
                    hintText: 'Enter your question or feedback',
                    border: OutlineInputBorder(borderSide: BorderSide(color: kPrimeryColor)),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 16.0),
                CustomButton(
                    width: width,
                    text: 'Send',
                    onPress: () async {
                      if (msgController.text.trim() == '') {
                        showSnackBar(context, 'Plsease enter your Quetion ');
                      } else {
                        try {
                          await FirebaseFirestore.instance.collection('helpmsg').add({
                            'UserUID': FirebaseAuth.instance.currentUser!.uid,
                            'email': FirebaseAuth.instance.currentUser!.email,
                            'message': msgController.text.trim(),
                            'datetime': DateTime.now(),
                          }).then((value) {
                            showSnackBar(context, 'Message sent');
                            Navigator.pop(context);
                          });
                        } on FirebaseException catch (e) {
                          showSnackBar(context, '${e.message}');
                        }
                      }
                    },
                    btnradius: 10),
                SizedBox(height: 32.0),
                Text(
                  'Need Support?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'If you have any questions, feedback or concerns, please don\'t hesitate to contact us via email or phone:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Email: support@recyclingapp.com',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Phone: +1 (123) 456-7890',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Our support team is available to assist you during business hours:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Monday - Friday: 9:00 AM to 5:00 PM',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'We appreciate your feedback and strive to provide the best customer support possible.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class FaqCard extends StatefulWidget {
  final String question;
  final String answer;

  const FaqCard({Key? key, required this.question, required this.answer}) : super(key: key);

  @override
  _FaqCardState createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: _isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            height: _isExpanded ? null : 0,
            child: SingleChildScrollView(
              child: Text(
                widget.answer,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
