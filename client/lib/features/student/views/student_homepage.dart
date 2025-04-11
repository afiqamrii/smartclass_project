import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/classCard.dart';
import 'package:smartclass_fyp_2024/features/student/views/widgets/tabs_item.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/class_models.dart';
import 'package:smartclass_fyp_2024/test.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  bool _isRefreshing = false; // Add loading state
  int limit = 5; // Set the limit for the number of items to display
  int _tabIndex = 0;

// Handle the refresh and reload data from provider
  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData();
    await ref.read(classDataProvider.future);
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the user data from provider
    final user = ref.watch(userProvider);
    final classData = ref.watch(classDataProvider);
    // final sumData = ref.watch(classDataProviderSummarizationStatus);

    return Scaffold(
      backgroundColor: const Color(0xFF0d1116),
      body: LiquidPullToRefresh(
        onRefresh: () => _handleRefresh(ref),
        color: const Color(0xFF0d1116),
        springAnimationDurationInMilliseconds: 350,
        showChildOpacityTransition: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                'assets/pictures/compPicture.jpg',
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Student name
                                Text(
                                  user.userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Figtree',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  user.roleId == 1
                                      ? "Student"
                                      : user.roleId == 2
                                          ? "Lecturer"
                                          : "PPH Staff",
                                  style: const TextStyle(
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Add search bar
                          _searchBarSection(),
                          const SizedBox(height: 20),
                          //Add card section
                          _cardSection(context),
                          const SizedBox(height: 20),
                          //Featured courses section
                          _featuresCourseSection(context),
                          const SizedBox(height: 30),
                          //Add card section
                          DefaultTabController(
                            length: 3,
                            initialIndex: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: Container(
                                    height: 35,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: TabBar(
                                      onTap: (index) {
                                        setState(() => _tabIndex = index);
                                      },
                                      physics: const BouncingScrollPhysics(),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      dividerColor: Colors.transparent,
                                      labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      indicator: ShapeDecoration(
                                        color: ColorConstants.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.black54,
                                      tabs: const [
                                        TabItem(
                                          title: "Today's Class",
                                        ),
                                        TabItem(
                                          title: 'Upcoming',
                                        ),
                                        TabItem(
                                          title: 'Summarization',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  child: IndexedStack(
                                    index:
                                        _tabIndex, // manage this via a state variable
                                    children: [
                                      _classSection(classData),
                                      _classSection(classData),
                                      _classSection(classData),
                                    ],
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _classSection(AsyncValue<List<ClassCreateModel>> classData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        classData.when(
          data: (data) {
            return GestureDetector(
              onTap: () => {
                // Handle tap on class card here
                // For example, navigate to class details page
              },
              child: Column(
                children: List.generate(
                  data.length > limit ? limit : data.length,
                  (index) => ClassCard(
                    className: data[index].courseName,
                    lecturerName: "Dr Nor Hassan",
                    summaryAvailablity: "Class Summary Available",
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            // Handle the error here
            return const Text(
              'Error loading class data',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            );
          },
          loading: () {
            // Show a loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        const SizedBox(height: 10),
        // Add a button to view all classes
        GestureDetector(
          onTap: () => {
            // Handle tap on "View All" button here
            // For example, navigate to class list page
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Show All',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _featuresCourseSection(BuildContext context) {
    return Column(
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
          height: 150, // Set a fixed height for the ListView
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none, // Make it horizontal
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10), // Add spacing between items
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
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
