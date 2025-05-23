import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/views/report_pic_fullscreen.dart';
import 'package:smartclass_fyp_2024/features/student/views/report_utility/views/student_update_report.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';

class StudentViewReportDetails extends ConsumerStatefulWidget {
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

  const StudentViewReportDetails({
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
  ConsumerState<StudentViewReportDetails> createState() =>
      _StudentViewReportDetailsState();
}

class _StudentViewReportDetailsState
    extends ConsumerState<StudentViewReportDetails> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
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
        onRefresh: _handleRefresh,
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
                    "Issue : ${widget.issueTitle}",
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
                    color: widget.issueStatus == "Resolved"
                        ? Colors.green
                        : Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.issueStatus,
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
              "Report ID: ${widget.reportId}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 5),
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
                    text: widget.userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                widget.issueDescription,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                _infoTile(
                  Icons.badge,
                  "User ID",
                  widget.userId,
                ),
                _infoTile(
                  Icons.meeting_room,
                  "Classroom Name",
                  widget.classroomName,
                ),
                _infoTile(
                  Icons.tag,
                  "Classroom ID",
                  widget.classroomId.toString(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Images (Tap to view)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullscreenImageViewer(
                          imageUrl: widget.imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
      actions: [
        if (widget.issueStatus != "Resolved")
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: const Icon(
                Icons.edit_note_rounded,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () => Navigator.push(
                context,
                toLeftTransition(
                  StudentUpdateReport(
                    reportId: widget.reportId,
                    issueTitle: widget.issueTitle,
                    issueDescription: widget.issueDescription,
                    userId: widget.userId,
                    issueStatus: widget.issueStatus,
                    imageUrl: widget.imageUrl,
                    classroomId: widget.classroomId,
                    userName: widget.userName,
                    classroomName: widget.classroomName,
                    createdAt: widget.createdAt,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
