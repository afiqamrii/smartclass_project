import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/admin/manage_report/providers/report_provider.dart';
import 'package:smartclass_fyp_2024/features/admin/manage_report/services/report_api.dart';
import 'package:smartclass_fyp_2024/features/admin/manage_report/views/report_pic_fullscreen.dart';
import 'package:smartclass_fyp_2024/shared/components/custom_buttom.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class ViewReportDetails extends ConsumerStatefulWidget {
  final int reportId;
  final String issueTitle;
  final String issueDescription;
  final String userId;
  final String issueStatus;
  final String imageUrl;
  final int classroomId;
  final String userName;
  final String classroomName;
  final String createdAt;

  const ViewReportDetails({
    super.key,
    required this.reportId,
    required this.issueTitle,
    required this.issueDescription,
    required this.userId,
    required this.issueStatus,
    required this.imageUrl,
    required this.classroomId,
    required this.userName,
    required this.classroomName,
    required this.createdAt,
  });

  @override
  ConsumerState<ViewReportDetails> createState() => _ViewReportDetailsState();
}

class _ViewReportDetailsState extends ConsumerState<ViewReportDetails> {
  // ignore: unused_field
  bool _isRefreshing = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // ignore: unused_field
  String? _selectedStatus;

  Future<void> _handleRefresh(WidgetRef ref) async {
    setState(() => _isRefreshing = true);

    await ref.read(userProvider.notifier).refreshUserData();
    // ignore: unused_result
    ref.refresh(reportListProvider);
    // ignore: unused_result
    ref.refresh(reportByIdProvider(widget.reportId));

    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();

    setState(() => _isRefreshing = false);
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<void> _updateStatus(WidgetRef ref, int reportId) async {
    // Update the status of the report
    await Future.any(
      [
        ReportApi.updateReportStatus(
          reportId,
        ),
      ],
    );

    // Show a success message
    Flushbar(
      message: 'Report updated successfully!',
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green.shade600,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    ).show(context);

    // Force refresh after status update
    // ignore: unused_result
    ref.refresh(reportByIdProvider(widget.reportId));
  }

  @override
  @override
  Widget build(BuildContext context) {
    final report = widget; // Use passed-in widget data

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
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Issue : ${report.issueTitle}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: report.issueStatus == "Resolved"
                        ? Colors.green
                        : Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    report.issueStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Report ID: ${report.reportId}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 5),

            /// Reported By
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Reported By : ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: report.userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /// Description
            const Text(
              "Issues Description :",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(6, 3),
                  ),
                ],
              ),
              child: Text(
                report.issueDescription,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Grid Info (2 columns)
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _infoTile(Icons.badge, "User ID", report.userId),
                _infoTile(
                    Icons.meeting_room, "Classroom Name", report.classroomName),
                _infoTile(
                    Icons.tag, "Classroom ID", report.classroomId.toString()),
              ],
            ),
            const SizedBox(height: 20),

            /// Image Section
            const Text("Images (Tap to view)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(1, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullscreenImageViewer(
                          imageUrl: report.imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: report.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              report.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),
                          )
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),

            /// Solved Button
            if (report.issueStatus != "Resolved")
              Padding(
                padding:
                    const EdgeInsets.only(right: 50.0, left: 50, bottom: 50),
                child: CustomButton(
                  text: "Mark as Solved",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text("Confirmation"),
                          content: const Text(
                              "Are you sure you want to mark this issue as solved?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateStatus(ref, report.reportId);
                                Navigator.pop(ctx);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.blueGrey,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Report Details",
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
}
