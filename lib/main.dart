import 'package:brunelrecycleprototype/pages/addnewpoint.dart';
import 'package:brunelrecycleprototype/pages/articlepage.dart';
import 'package:brunelrecycleprototype/pages/contactuspage.dart';
import 'package:brunelrecycleprototype/pages/editprofilepage.dart';
import 'package:brunelrecycleprototype/pages/forgetpassword.dart';
import 'package:brunelrecycleprototype/pages/helpandsupportpage.dart';
import 'package:brunelrecycleprototype/pages/leaderboardpage.dart';
import 'package:brunelrecycleprototype/pages/loginpage.dart';
import 'package:brunelrecycleprototype/pages/pointpage.dart';
import 'package:brunelrecycleprototype/pages/privacypage.dart';
import 'package:brunelrecycleprototype/pages/profilepage.dart';
import 'package:brunelrecycleprototype/pages/rewardScreen.dart';
import 'package:brunelrecycleprototype/pages/signup.dart';
import 'package:brunelrecycleprototype/pages/temppages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        LoginPage.id: (context) => LoginPage(),
        SignUpPage.id: (context) => SignUpPage(),
        ForgetPasswordPage.id: (context) => ForgetPasswordPage(),
        ProfilePage.id: (context) => ProfilePage(),
        PointsPage.id: (context) => PointsPage(),
        AddNewPoint.id: (context) => AddNewPoint(),
        ArticlePage.id: (context) => ArticlePage(),
        LeaderBoardPage.id: (context) => LeaderBoardPage(),
        RewardPage.id: (context) => RewardPage(),
        EditProfilePage.id: (context) => EditProfilePage(),
        PrivacyPage.id: (context) => PrivacyPage(),
        HelpSupportPage.id: (context) => HelpSupportPage(),
        ContactUsPage.id: (context) => ContactUsPage(),
      },
    );
  }
}
