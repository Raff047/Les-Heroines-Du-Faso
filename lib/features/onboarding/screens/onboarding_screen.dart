// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:health_app/features/auth/screens/login.dart';
import 'package:health_app/features/onboarding/screens/intro_screen_one.dart';
import 'package:health_app/features/onboarding/screens/intro_screen_three.dart';
import 'package:health_app/features/onboarding/screens/intro_screen_two.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // controller to keep track of which page we're in
  int _currentPage = 1;
  final PageController _pageController = PageController();

  //keep track if we're on last page
  bool onLastPage = false;

  // too keep track
  @override
  Widget build(BuildContext context) {
    int pageCount = 3;
    return Scaffold(
      body: Stack(
        children: [
          //page view
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index + 1;
                onLastPage = (index == 2);
              });
            },
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: IntroScreenOne(),
              ),
              IntroScreenTwo(),
              IntroScreenThree(),
            ],
          ),

          // top middle page index indecator
          Container(
            alignment: Alignment(-0.8, -0.85),
            child: SizedBox(
              height: 50.0,
              child: Row(
                mainAxisSize: MainAxisSize.min, // set mainAxisSize to min
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30.0,
                    height: 30.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.shade200,
                            offset: Offset(0, 10.0),
                            blurStyle: BlurStyle.normal,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          )
                        ],
                        color: Colors.pink.shade300,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      '$_currentPage',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 15.0,
                  ),

                  //dot indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pageCount,
                    effect: WormEffect(
                      dotHeight: 5.0,
                      dotWidth: 5.0,
                      dotColor: Colors.pink.shade100,
                      activeDotColor: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Suivant Sauter
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // skip
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(2,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: Text('Sauter'),
                ),

                // next or done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          // push to login screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text('Continue'),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text('Suivant')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
