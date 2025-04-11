import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;
  final IconData? icon;

  const TabItem({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12), // Make text smaller
          ),
        ],
      ),
    );
  }
}
