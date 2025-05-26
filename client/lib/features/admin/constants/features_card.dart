// Function to create a card with a specific width, height, and child widget
import 'package:flutter/material.dart';

Card featureCard(
    {required String imagePath,
    required String title,
    required Color color,
    VoidCallback? onTap,
    BuildContext? context}) {
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
        width: MediaQuery.of(context!).size.width * 0.43,
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
