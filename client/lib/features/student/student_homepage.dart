import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/test.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  bool _isRefreshing = false; // Add loading state

// Handle the refresh and reload data from provider
  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true; // Set loading state to true
    });

    // Wait for new data to load
    await Future.delayed(
      const Duration(seconds: 3),
    );

    setState(() {
      _isRefreshing = false; // Set loading state to false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1116),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: 90,
            backgroundColor: const Color(0xFF0d1116), // Set background color
            elevation: 0, // No shadow
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin, // Avoid stretching/mismatch
              background: Container(
                color: const Color(0xFF0d1116),
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Skeletonizer(
                  enabled: _isRefreshing,
                  effect: const ShimmerEffect(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                              'assets/pictures/compPicture.jpg',
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Student name
                              Text(
                                'Afiq Amrii',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Figtree',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                "Student",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'FigtreeRegular',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyWidget()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Skeletonizer(
              enabled: _isRefreshing,
              effect: const ShimmerEffect(),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
