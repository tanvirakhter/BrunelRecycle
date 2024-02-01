import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:flutter/material.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';

class ContactUsPage extends StatefulWidget {
  static String id = 'ContactUs';
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 4),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Contact US', style: TextStyle(fontSize: 20, color: kBlackColor, fontWeight: FontWeight.w600)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/icons/BackArrow.png')),
              ],
            ),
            SizedBox(
              height: hight * 0.7,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'If you have any questions or concerns, please contact us at the following address:',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '1234 Main Street\nAnytown, USA 12345\nPhone: (555) 555-5555\nEmail: info@example.com',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'General FAQs',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Here are some frequently asked questions about recycling that may help you:',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  FaqCard(
                    question: 'What can I recycle?',
                    answer:
                        'Most recycling programs accept paper, plastic, glass, and metal. Check with your local recycling program for specific guidelines.',
                  ),
                  FaqCard(
                    question: 'How do I prepare my recyclables for pickup?',
                    answer:
                        'Rinse out containers and remove any caps or lids. Flatten cardboard boxes and stack them neatly. Check with your local recycling program for specific instructions.',
                  ),
                  FaqCard(
                    question: 'Can I recycle electronics?',
                    answer: 'Yes, many electronics can be recycled. Check with your local recycling program for specific guidelines.',
                  ),
                  FaqCard(
                    question: 'What happens to my recyclables after they are picked up?',
                    answer:
                        'Recyclables are sorted, cleaned, and processed into new products. Some materials, such as paper and cardboard, are turned into new paper products. Others, such as plastic and metal, are melted down and used to make new products.',
                  ),
                ],
              ),
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
