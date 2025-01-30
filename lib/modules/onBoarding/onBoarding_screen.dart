import 'package:flutter/material.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/onBoarding/first_screen.dart';
import 'package:social_app/modules/onBoarding/second_screen.dart';
import 'package:social_app/modules/onBoarding/third_screen.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class OnboardingScreen extends StatefulWidget {
   OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  controller: pageController,
                  children: [
                    FirstScreen(),
                    SecondScreen(),
                    ThirdScreen(),
                  ],
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIndicator(isActive: currentIndex == 0),
                SizedBox(width: 5,),
                CustomIndicator(isActive: currentIndex == 1),
                SizedBox(width: 5,),
                CustomIndicator(isActive: currentIndex == 2),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      CacheHelper.saveData(key: 'OnBoarding', value: true);
                    },
                    child: Text('Skip', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  InkWell(
                    onTap: () {
                      if (currentIndex == 2) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        CacheHelper.saveData(key: 'OnBoarding', value: true);
                      } else {
                        pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(255, 255, 199, 59),
                      ),
                      child: Text('Next', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class CustomIndicator extends StatelessWidget {
  final bool isActive;
  const CustomIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isActive ? Color.fromARGB(255, 255, 199, 59) : Colors.grey,
        ),
        width: isActive ? 30 : 10,
        height: 10,
    );
  }
}
