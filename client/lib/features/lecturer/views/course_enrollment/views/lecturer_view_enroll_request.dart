// ignore_for_file: unused_result

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartclass_fyp_2024/features/lecturer/views/course_enrollment/providers/enroll_request_provider.dart';

import '../services/course_enrollment_request_api.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class LecturerViewEnrollRequest extends ConsumerStatefulWidget {
  final String lecturerId;
  final int courseId;

  const LecturerViewEnrollRequest({
    super.key,
    required this.lecturerId,
    required this.courseId,
  });

  @override
  ConsumerState<LecturerViewEnrollRequest> createState() =>
      _LecturerViewEnrollRequestState();
}

class _LecturerViewEnrollRequestState
    extends ConsumerState<LecturerViewEnrollRequest> {
  late TextEditingController _searchController;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
      setState(() {}); // for suffixIcon clear visibility
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to update the enrollment request status
  Future<void> updateEnrollmentRequestStatus(
      int enrollmentId, String status) async {
    try {
      final response =
          await CourseEnrollmentRequestApi.updateEnrollmentRequestStatus(
        enrollmentId,
        status,
      );

      // Show success Flushbar
      await Flushbar(
        message: 'Request $status successfully!',
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

      // Refresh the request list
      ref.refresh(enrollmentRequestListProvider(
        EnrollmentRequestArgs(widget.lecturerId, widget.courseId),
      ));
    } catch (error) {
      // Show error Flushbar
      Flushbar(
        message: 'Failed to $status request: $error',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
      ).show(context);
    }
  }

  void _onRefresh() async {
    // Refresh the request list
    ref.refresh(enrollmentRequestListProvider(
      EnrollmentRequestArgs(widget.lecturerId, widget.courseId),
    ));
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
    final args = EnrollmentRequestArgs(widget.lecturerId, widget.courseId);
    final asyncRequests = ref.watch(enrollmentRequestListProvider(args));
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      floatingActionButton: asyncRequests.maybeWhen(
        data: (requests) {
          final pending = requests.where((r) => r.status == 'Pending');
          if (pending.isEmpty) return null;
          // Show "Approve All" button only if there are pending requests more than 1
          if (pending.length <= 1) return null;
          // Show "Approve All" button
          return FloatingActionButton.extended(
            onPressed: () {
              _showApproveAllDialog(context, ref, args, pending.toList());
            },
            extendedPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            foregroundColor: Colors.white,
            elevation: 0,
            icon: const Icon(
              Icons.done_all,
              size: 18,
            ),
            label: const Text(
              "Approve All",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.green[700],
          );
        },
        orElse: () => null,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const ClassicHeader(
          releaseIcon: Icon(
            Icons.arrow_upward,
            color: Colors.grey,
          ),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(searchQueryProvider.notifier).state = val;
                },
                onClear: () {
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
            ),
            asyncRequests.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => const SliverFillRemaining(
                child: Center(child: Text('Failed to load requests')),
              ),
              data: (requests) {
                final filtered = requests.where((req) {
                  final query = searchQuery.toLowerCase();
                  return req.studentName.toLowerCase().contains(query) ||
                      req.studentId.toLowerCase().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No matching enrollment requests.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final req = filtered[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person,
                                    size: 20, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      req.studentName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Matric No.: ${req.studentId}',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Requested At: ${_formatDate(DateTime.parse(req.requestedAt))}',
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        if (req.status.toLowerCase() ==
                                            'pending')
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              //Make alert dialog to confirm approve
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text(
                                                    "Approve Request",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Are you sure you want to approve the enrollment request from ${req.studentName}?",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        // Call the function to update the status
                                                        updateEnrollmentRequestStatus(
                                                          req.enrollmentId,
                                                          'Approved',
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green),
                                                      child: const Text(
                                                        "Approve",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.check,
                                              size: 14,
                                            ),
                                            label: const Text(
                                              "Approve",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green[600],
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 6,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 8),
                                        if (req.status.toLowerCase() ==
                                            'pending')
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              // Make alert dialog to confirm reject
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text(
                                                    "Reject Request",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Are you sure you want to reject the enrollment request from ${req.studentName}?",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        updateEnrollmentRequestStatus(
                                                          req.enrollmentId,
                                                          'Rejected',
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                      child: const Text(
                                                        "Reject",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              size: 14,
                                            ),
                                            label: const Text(
                                              "Reject",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red[600],
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 30,
                                                vertical: 6,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 8),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Enrollment Requests",
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

  void _showApproveAllDialog(BuildContext context, WidgetRef ref,
      EnrollmentRequestArgs args, List<dynamic> requests) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Approve All Requests",
        ),
        content: Text(
          "Are you sure you want to approve all ${requests.length} pending requests?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement your approveAll logic here
              // Example: ref.read(enrollmentRequestListProvider(args).notifier).approveAll(requests);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text(
              "Approve All",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
}

// Reusable Search Bar Delegate
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final VoidCallback onClear;

  _SearchBarDelegate({
    required this.onChanged,
    required this.controller,
    required this.onClear,
  });

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 23),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey, size: 17),
                    onPressed: onClear,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) => true;
}
