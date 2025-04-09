import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
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
            backgroundColor:
                ColorConstants.backgroundColor, // Set background color
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
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        //Add search bar
                        _searchBarSection(),
                        const SizedBox(height: 20),
                        //Add card section
                        _cardSection(context),
                        const SizedBox(height: 20),
                        //Featured courses section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Featured Courses',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Figtree',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height:
                                  150, // Set a fixed height for the ListView
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none, // Make it horizontal
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 10), // Add spacing between items
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _cardSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.41,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.41,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        )
      ],
    );
  }

  SearchBar _searchBarSection() {
    return SearchBar(
      backgroundColor: WidgetStatePropertyAll(
        Colors.grey[100], // Set background color
      ), // Set background color
      leading: const Icon(
        Icons.search,
        color: Colors.grey,
      ),
      hintText: 'Search here...',
      shadowColor: WidgetStatePropertyAll(
        Colors.grey[300], // Set shadow color
      ),
      hintStyle: const WidgetStatePropertyAll(
        TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: 'FigtreeRegular',
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.all(8),
      ),
    );
  }
}
