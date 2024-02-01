import 'package:brunelrecycleprototype/pages/articlepage.dart';
import 'package:brunelrecycleprototype/pages/leaderboardpage.dart';
import 'package:brunelrecycleprototype/pages/pointpage.dart';
import 'package:brunelrecycleprototype/pages/profilepage.dart';
import 'package:brunelrecycleprototype/pages/rewardScreen.dart';
import 'package:brunelrecycleprototype/utlitis/constant.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigatiorBar extends StatelessWidget {
  CustomBottomNavigatiorBar({
    super.key,
    required this.indexPage,
  });
  final int indexPage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBottomNavigatiorBarItem(
              indexPage: indexPage,
              tabNumber: 0,
              image: 'assets/icons/Leaderboard.png',
              label: 'Leaderboard',
              onTap: () {
                Navigator.pushNamed(context, LeaderBoardPage.id);
              }),
          CustomBottomNavigatiorBarItem(
              indexPage: indexPage,
              tabNumber: 1,
              image: 'assets/icons/Article.png',
              label: 'Article',
              onTap: () {
                Navigator.pushNamed(context, ArticlePage.id);
              }),
          CustomBottomNavigatiorBarItem(
              indexPage: indexPage,
              tabNumber: 2,
              image: 'assets/icons/Gift.png',
              label: 'Rewards',
              onTap: () {
                Navigator.pushNamed(context, RewardPage.id);
              }),
          CustomBottomNavigatiorBarItem(
              indexPage: indexPage,
              tabNumber: 3,
              image: 'assets/icons/Points.png',
              label: 'Points',
              onTap: () {
                Navigator.pushNamed(context, PointsPage.id);
              }),
          CustomBottomNavigatiorBarItem(
              indexPage: indexPage,
              tabNumber: 4,
              image: 'assets/icons/Profile.png',
              label: 'Profile',
              onTap: () {
                Navigator.pushNamed(context, ProfilePage.id);
              }),
        ],
      ),
    );
  }
}

class CustomBottomNavigatiorBarItem extends StatelessWidget {
  const CustomBottomNavigatiorBarItem({
    super.key,
    required this.indexPage,
    required this.tabNumber,
    required this.image,
    required this.label,
    required this.onTap,
  });

  final int indexPage;
  final int tabNumber;
  final String image;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ImageIcon(AssetImage(image), color: indexPage == tabNumber ? kSecondaryColor : kBlackColor),
          SizedBox(
            height: 2,
          ),
          Text(
            label,
            style: TextStyle(color: indexPage == tabNumber ? kSecondaryColor : kBlackColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
