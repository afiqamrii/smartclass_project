import 'package:flutter/material.dart';

class LecturerViewsummarization extends StatelessWidget {
  const LecturerViewsummarization({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Summarization",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Padding(
            padding: EdgeInsets.only(left: 9.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 21,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 13.0),
                child: Container(
                  child: const Text(
                    "Summarization Results",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note),
                  iconSize: 28,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
