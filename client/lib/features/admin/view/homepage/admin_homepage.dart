import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/models/report_models.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/providers/report_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/features/admin/view/constants/maintainance_card.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import '../manage_report/views/admin_view_report.dart';

class AdminHomepage extends ConsumerStatefulWidget {
  const AdminHomepage({super.key});

  @override
  ConsumerState<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends ConsumerState<AdminHomepage> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData();
    // ignore: await_only_futures
    await ref.read(reportListProvider);
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the user data from the provider
    final user = ref.watch(userProvider);

    //Get report data from the provider
    final reportList = ref.watch(reportListProvider);

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
              backgroundColor: ColorConstants.backgroundColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  color: const Color(0xFF0d1116),
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  child: Skeletonizer(
                    enabled: _isRefreshing,
                    effect: const ShimmerEffect(),
                    child: _topHeaderSection(user, context),
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
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _searchBarSection(),
                          const SizedBox(height: 20),
                          _consumptionSection(context),
                          const SizedBox(height: 20),
                          const Text(
                            'Features',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _featuresSection(context),
                          const SizedBox(height: 20),
                          const Text(
                            'Maintenance',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _maintainanceCardSection(context, reportList),
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

  // Function to create a card with a specific width, height, and child widget
  Card _featureCard({
    required String imagePath,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.grey[100],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.43,
          height: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 29,
                backgroundColor: color,
                child: Image.asset(
                  imagePath,
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _featuresSection(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 3.0,
        runSpacing: 3.0,
        children: [
          _featureCard(
            imagePath: 'assets/icons/remote.png',
            title: 'Control Utilities',
            color: Colors.blue,
          ),
          _featureCard(
            imagePath: 'assets/icons/maintainance.png',
            title: 'Reports',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              toLeftTransition(
                const AdminViewReport(),
              ),
            ),
          ),
          _featureCard(
            imagePath: 'assets/icons/remote.png',
            title: 'Smart Lighting',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  SizedBox _maintainanceCardSection(BuildContext context,
      AsyncValue<List<UtilityIssueModel>> reportListProvider) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 5),
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        children: reportListProvider.when(
          data: (reportList) {
            return reportList.map((report) {
              return MaintenanceCard(
                title: report.issueTitle,
                description: report.issueDescription,
                date: "21/10/2023",
                status: report.issueStatus,
              );
            }).toList();
          },
          error: (error, stackTrace) => [Text('Error: $error')],
          loading: () => [const Center(child: CircularProgressIndicator())],
        ),
      ),
    );
  }

  Row _topHeaderSection(User user, BuildContext context) {
    return Row(
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const MyWidget()),
              // );
            },
          ),
        ),
      ],
    );
  }

  Container _consumptionSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(6, 7),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Average Consumption',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'FigtreeRegular',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '+35%',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '25.3 kWh',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'FigtreeRegular',
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Image.asset(
              'assets/pictures/electric.png',
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  SearchBar _searchBarSection() {
    return SearchBar(
      backgroundColor: WidgetStatePropertyAll(
        Colors.grey[100],
      ),
      leading: const Icon(
        Icons.search,
        color: Colors.grey,
      ),
      hintText: 'Search here...',
      shadowColor: WidgetStatePropertyAll(
        Colors.grey[300],
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
