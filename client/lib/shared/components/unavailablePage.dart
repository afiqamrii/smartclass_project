// ignore: file_names
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Unavailablepage extends StatefulWidget {
  final String message;
  final String animation;

  const Unavailablepage({
    super.key,
    required this.message,
    required this.animation,
  });

  @override
  State<StatefulWidget> createState() => _UnavailablepageState();
}

class _UnavailablepageState extends State<Unavailablepage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            children: [
              LottieBuilder.asset(
                widget.animation,
                width: 150,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 10),
              Text(
                widget.message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
