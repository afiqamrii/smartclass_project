import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/constants/features_card.dart';
import 'package:smartclass_fyp_2024/features/admin/manage_report/providers/report_provider.dart';
import 'package:smartclass_fyp_2024/features/super_admin/manage_user/views/super_admin_view_all_users.dart';
import 'package:smartclass_fyp_2024/features/super_admin/pending_approval/views/super_admin_view_pending_approval.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/models/user.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class SuperAdminHomepage extends ConsumerStatefulWidget {
  const SuperAdminHomepage({super.key});

  @override
  ConsumerState<SuperAdminHomepage> createState() => _SuperAdminHomepageState();
}

class _SuperAdminHomepageState extends ConsumerState<SuperAdminHomepage> {
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
    // ignore: unused_local_variable
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
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        // top: 5,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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

  Container _featuresSection(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 3.0,
        runSpacing: 3.0,
        children: [
          featureCard(
            context: context,
            imagePath: 'assets/pictures/management.png',
            title: 'Manage Users',
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              toLeftTransition(
                const SuperAdminViewAllUsers(),
              ),
            ),
          ),
          // featureCard(
          //   context: context,
          //   imagePath: 'assets/pictures/management.png',
          //   title: 'Manage Roles',
          //   color: Colors.brown,
          //   // onTap: () => Navigator.push(
          //   //   context,
          //   //   toLeftTransition(
          //   //     const AcademicAdminViewAllClass(),
          //   //   ),
          //   // ),
          // ),
          featureCard(
            context: context,
            imagePath: 'assets/icons/pending.png',
            title: 'Pending Approvals',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              toLeftTransition(
                const SuperAdminViewPendingApproval(),
              ),
            ),
          ),
        ],
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
                    fontSize: 17,
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
                          : user.roleId == 3
                              ? "PPH Staff"
                              : user.roleId == 4
                                  ? "Academic Staff"
                                  : "Super Admin",
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'FigtreeRegular',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 10.0),
        //   child: IconButton(
        //     icon: const Icon(
        //       Icons.notifications,
        //       color: Color.fromARGB(255, 238, 238, 238),
        //     ),
        //     onPressed: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) => const MyWidget()),
        //       // );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
