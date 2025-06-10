import 'package:flutter/material.dart';

class CourseStatusCard extends StatelessWidget {
  final String courseName;
  final String courseCode;
  final String imageUrl;
  final bool isVerified; // true = Verified, false = Pending

  const CourseStatusCard({
    super.key,
    required this.courseName,
    required this.courseCode,
    required this.imageUrl,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias, // ensures child content respects radius
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image with overlay and status badge
          Stack(
            children: [
              // Background image
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

              // Gradient overlay
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

              // Course name and code
              Positioned(
                bottom: 15,
                left: 15,
                right: 0,
                child: Text(
                  '$courseCode - $courseName',
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'Figtree',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Status badge
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
                    isVerified ? "Verified" : "Pending",
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
        ],
      ),
    );
  }
}
