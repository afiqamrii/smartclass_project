import 'package:flutter/material.dart';

class CourseStatusCard extends StatelessWidget {
  final String courseName;
  final String courseCode;
  final String lecturerName;
  final String imageUrl;
  final bool isVerified;
  final int enrollmentId; // optional field for enrollment ID
  final VoidCallback? onWithdraw; // add this to handle button tap

  const CourseStatusCard({
    super.key,
    required this.courseName,
    required this.courseCode,
    required this.lecturerName,
    required this.imageUrl,
    required this.isVerified,
    required this.enrollmentId, // required field for enrollment ID
    this.onWithdraw, // optional callback
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image and overlay
          Stack(
            children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/pictures/compPicture.jpg',
                    fit: BoxFit.cover,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$courseCode - $courseName',
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Figtree',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Lecturer - $lecturerName',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Figtree',
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? Colors.green.withOpacity(0.9)
                        : Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    isVerified ? "Approved" : "Pending",
                    style: const TextStyle(
                      fontSize: 9,
                      fontFamily: 'Figtree',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Withdraw button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onWithdraw,
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 16,
                ),
                label: const Text(
                  'Withdraw Enrollment',
                  style: TextStyle(
                    fontFamily: 'Figtree',
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
