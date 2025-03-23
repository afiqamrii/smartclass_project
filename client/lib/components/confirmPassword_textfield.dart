import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class ConfirmPasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController; // Main password controller
  final String hintText;
  bool obscureText;
  final String? Function(String?)? validator;

  ConfirmPasswordTextfield({
    super.key,
    required this.controller,
    required this.passwordController,
    required this.hintText,
    required this.obscureText,
    this.validator,
  });

  @override
  State<ConfirmPasswordTextfield> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextfield> {
  bool _isPasswordSame = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to both password and confirm password fields
    widget.controller.addListener(onPasswordChanged);
    widget.passwordController.addListener(onPasswordChanged);
  }

  void onPasswordChanged() {
    setState(() {
      // Check if password and confirm password are the same
      String password = widget.passwordController.text;
      String confirmPassword = widget.controller.text;

      // Check if either password or confirm password is empty
      if (password.isEmpty || confirmPassword.isEmpty) {
        _isPasswordSame = false; // Set _isPasswordSame to false
      } else {
        // If both password and confirm password are not empty and same
        _isPasswordSame =
            password == confirmPassword; // Set _isPasswordSame to true
      }
    });
  }

  @override
  void dispose() {
    // Clean up listeners to avoid memory leaks
    widget.controller.removeListener(onPasswordChanged);
    widget.passwordController.removeListener(onPasswordChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
                icon: widget.obscureText
                    ? const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                        size: 20,
                      )
                    : const Icon(
                        Icons.visibility,
                        size: 20,
                      ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            validator: widget.validator,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 35,
                height: 35,
                child: _isPasswordSame
                    ? Center(
                        child: LottieBuilder.asset(
                          "assets/animations/passwordCheck.json",
                          width: 150,
                          height: 150,
                          repeat: false,
                          fit: BoxFit.fill,
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
              ),
              const SizedBox(width: 5),
              if (_isPasswordSame) ...[
                Text(
                  "Password Matched",
                  style: TextStyle(color: Colors.grey.shade800),
                ),
              ] else ...[
                Text(
                  "Password Not Matched",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
