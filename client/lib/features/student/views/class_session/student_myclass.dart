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
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/pictures/logo.png'),
                ),
                const SizedBox(width: 15),
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Dr. John Doe",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Figtree',
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Class Summary Available",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Figtree',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: const LectBottomNavBar(initialIndex: 1),
    );
  }
}
