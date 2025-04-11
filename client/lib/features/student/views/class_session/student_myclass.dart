import 'package:flutter/material.dart';

class StudentMyclass extends StatelessWidget {
  const StudentMyclass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Class"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 255, 249, 249),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: IntrinsicHeight(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/pictures/compPicture.jpg',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Customer Journey Maps",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Figtree',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Dr. John Doe",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Figtree',
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "Class Summary Available",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Figtree',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const LectBottomNavBar(initialIndex: 1),
    );
  }
}
