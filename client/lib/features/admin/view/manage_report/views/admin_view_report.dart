import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/features/admin/view/constants/maintainance_card.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/models/report_models.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/providers/report_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class AdminViewReport extends ConsumerStatefulWidget {
  const AdminViewReport({super.key});

  @override
  ConsumerState<AdminViewReport> createState() => _AdminViewReportState();
}

class _AdminViewReportState extends ConsumerState<AdminViewReport> {
  bool _isRefreshing = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData();
    await ref.read(reportListProvider);

    await Future.delayed(const Duration(seconds: 3));

    _refreshController.refreshCompleted();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 1));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // Get the user data from the provider
    // ignore: unused_local_variable
    final user = ref.watch(userProvider);

    // Get report data from the provider
    final reportList = ref.watch(reportListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(
          releaseIcon: Icon(
            Icons.arrow_upward,
            color: Colors.grey,
          ),
        ),
        onRefresh: () => _handleRefresh(ref),
        onLoading: _onLoading,
        physics: const BouncingScrollPhysics(),
        child: ListView(
          children: [
            Skeletonizer(
              enabled: _isRefreshing,
              effect: const ShimmerEffect(),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const Text(
                      "All Reported Issues",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'FigtreeExtraBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _maintainanceCardSection(context, reportList),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

SizedBox _maintainanceCardSection(BuildContext context,
    AsyncValue<List<UtilityIssueModel>> reportListProvider) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.5,
    child: ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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

AppBar _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: const Text(
      "Reported Issues",
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 20,
        color: Colors.black,
      ),
      onPressed: () => Navigator.pop(context),
    ),
  );
}
