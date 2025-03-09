import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartclass_fyp_2024/intro_page/introPage1.dart';
import 'package:smartclass_fyp_2024/intro_page/introPage2.dart';
import 'package:smartclass_fyp_2024/intro_page/introPage3.dart';
import 'package:smartclass_fyp_2024/intro_page/introPage4.dart';
import 'package:smartclass_fyp_2024/login/lecturer_login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Controller for page view
  PageController _controller = PageController();

  //Keep track of page if we are on the last page or not
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 191, 136, 236),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 100.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Let's Getting\nStarted",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'FigtreeExtraBold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Wrap PageView in Expanded to provide bounded height
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) => {
                      setState(() {
                        onLastPage = index == 3;
                      }),
                    },
                    clipBehavior: Clip.none, // Prevents unwanted white space
                    children: const [
                      Intropage1(),
                      Intropage2(),
                      Intropage3(),
                      Intropage4(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dot indicator
          Container(
            alignment: const Alignment(0, 0.65),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                onLastPage
                    ?
                    //Skip button
                    GestureDetector(
                        onTap: () {
                          _controller.jumpToPage(4);
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : //Skip button
                    GestureDetector(
                        onTap: () {
                          _controller.jumpToPage(4);
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color.fromARGB(255, 192, 28, 113),
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Color.fromARGB(255, 192, 28, 113),
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                  ),
                ),

                // Next button or done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LecturerLoginPage()));
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Color.fromARGB(255, 192, 28, 113),
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
