import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';

class ReportUtilityPage extends StatefulWidget {
  const ReportUtilityPage({super.key});

  @override
  State<ReportUtilityPage> createState() => _ReportUtilityPageState();
}

class _ReportUtilityPageState extends State<ReportUtilityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Report Utility",
          style: TextStyle(
            fontSize: 17,
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Report Utility Page Content'),
      ),
    );
  }
}
