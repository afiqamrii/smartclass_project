import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/features/admin/view/constants/maintainance_card.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/models/report_models.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/providers/report_provider.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/views/view_report_details.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class AdminViewReport extends ConsumerStatefulWidget {
  const AdminViewReport({super.key});

  @override
  ConsumerState<AdminViewReport> createState() => _AdminViewReportState();
}

class _AdminViewReportState extends ConsumerState<AdminViewReport> {
  bool _isRefreshing = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Set<String> selectedFilters = {'All'};
  final List<String> dateFilters = [
    'All',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days'
  ];
  final List<String> statusFilters = ['Pending', 'Resolved'];

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() {
      _isRefreshing = true;
    });

    await ref.read(userProvider.notifier).refreshUserData();
    // ignore: unused_result
    ref.refresh(reportListProvider);

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
                    const SizedBox(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: [
                          ...dateFilters.map((filter) {
                            final isSelected = selectedFilters.contains(filter);
                            return ChoiceChip(
                              label: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedFilters
                                      ..removeAll(
                                          dateFilters) // only allow 1 date filter
                                      ..add(filter);
                                  } else {
                                    selectedFilters.remove(filter);
                                  }
                                });
                              },
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: isSelected
                                    ? BorderSide.none
                                    : BorderSide(color: Colors.grey.shade400),
                              ),
                              elevation: isSelected ? 3 : 0,
                              pressElevation: 5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                            );
                          }),
                          ...statusFilters.map((filter) {
                            final isSelected = selectedFilters.contains(filter);
                            return ChoiceChip(
                              label: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedFilters.add(filter);
                                  } else {
                                    selectedFilters.remove(filter);
                                  }
                                });
                              },
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: isSelected
                                    ? BorderSide.none
                                    : BorderSide(color: Colors.grey.shade400),
                              ),
                              elevation: isSelected ? 3 : 0,
                              pressElevation: 5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 5),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _maintainanceCardSection(
                        context, reportList, selectedFilters),
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

SizedBox _maintainanceCardSection(
  BuildContext context,
  AsyncValue<List<UtilityIssueModel>> reportListProvider,
  Set<String> selectedFilters,
) {
  return SizedBox(
    child: reportListProvider.when(
      data: (reportList) {
        final filteredList = _filterIssues(reportList, selectedFilters);

        if (filteredList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                'No reports found for this filter.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: filteredList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final report = filteredList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    toLeftTransition(
                      ViewReportDetails(reportId: report.issueId),
                    ),
                  );
                },
                child: MaintenanceCard(
                  title: report.issueTitle,
                  description: report.issueDescription,
                  date: report.createdAt,
                  status: report.issueStatus,
                ),
              );
            },
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    ),
  );
}

List<UtilityIssueModel> _filterIssues(
    List<UtilityIssueModel> data, Set<String> filters) {
  final now = DateTime.now();
  String? selectedDateFilter = filters
      .intersection({'Yesterday', 'Last 7 Days', 'Last 30 Days'}).firstOrNull;

  final selectedStatusFilters = filters.intersection({'Pending', 'Resolved'});

  return data.where((item) {
    try {
      final parsed = DateFormat('dd MMM yyyy, h:mm a').parse(item.createdAt);

      // Date filter check
      bool matchesDate = true;
      if (selectedDateFilter != null) {
        switch (selectedDateFilter) {
          case 'Yesterday':
            matchesDate =
                parsed.day == now.subtract(const Duration(days: 1)).day &&
                    parsed.month == now.month &&
                    parsed.year == now.year;
            break;
          case 'Last 7 Days':
            matchesDate = parsed.isAfter(now.subtract(const Duration(days: 7)));
            break;
          case 'Last 30 Days':
            matchesDate =
                parsed.isAfter(now.subtract(const Duration(days: 30)));
            break;
        }
      }

      // Status filter check
      bool matchesStatus = selectedStatusFilters.isEmpty ||
          selectedStatusFilters.contains(item.issueStatus);

      return matchesDate && matchesStatus;
    } catch (_) {
      return false;
    }
  }).toList();
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
