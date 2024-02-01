import 'package:flutter/material.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';

class PrivacyPage extends StatelessWidget {
  static String id = 'PrivacyPage';
  const PrivacyPage({Key? key}) : super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Privacy policy', style: TextStyle(fontSize: 20, color: kBlackColor, fontWeight: FontWeight.w600)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/icons/BackArrow.png')),
              ],
            ),
            SizedBox(
              height: hight * 0.72,
              child: ListView(
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'We respect your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and disclose your personal information in connection with our services.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'What information we collect',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'We collect information that you provide to us, such as your name, email address, and other contact information. We may also collect information about how you use our services, such as your device type and operating system, and your interactions with our website or mobile app.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'How we use your information',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'We use your information to provide and improve our services, to communicate with you, and to personalize your experience with our website or mobile app. We may also use your information to comply with legal or regulatory requirements, or to protect our rights or the rights of others.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'How we share your information',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'We may share your information with third-party service providers who help us to provide our services or to analyze how our services are used. We may also share your information with law enforcement or regulatory authorities when required by law.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Changes to this Privacy Policy',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'We may update this Privacy Policy from time to time. If we make material changes, we will notify you by email or by posting a notice on our website or mobile app.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
