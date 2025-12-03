// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:ezee/screens/dashboard.dart';
import 'package:ezee/screens/hotel_operation.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}


class _AuthPageState extends State<AuthPage> {
  bool isSignup = false;
  bool isHotelAdmin = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Jump to top when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            reverse: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
  child: Image.asset(
    'lib/assets/images/ezee.png',
    width: 200, // set desired width
    height: 200, // set desired height
    fit: BoxFit.contain, // or cover, fill, etc.
  ),
),

                    Center(
                      child: const Text(
                        "Welcome to Ezee Hotel",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(child: const Text("Login or create an account to continue")),
                    const SizedBox(height: 30),

                    // Toggle for role
                    Center(
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(12),
                        selectedColor: Colors.white,
                        fillColor: Colors.black,
                        color: Colors.black,
                        isSelected: [!isHotelAdmin, isHotelAdmin],
                        onPressed: (index) {
                          setState(() {
                            isHotelAdmin = index == 1;
                          });
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Guest"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Hotel Admin"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Name (only if isSignup)
if (isSignup)
  TextField(
    controller: _nameController,
    decoration: InputDecoration(
      labelText: "Full Name",
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      labelStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
    ),
  ),
if (isSignup) const SizedBox(height: 16),

// Email
TextField(
  controller: _emailController,
  decoration: InputDecoration(
    labelText: "Email",
    filled: true,
    fillColor: const Color(0xFFF5F5F5),
    labelStyle: const TextStyle(color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black, width: 1.2),
    ),
  ),
),
const SizedBox(height: 16),

// Password
TextField(
  controller: _passwordController,
  obscureText: true,
  decoration: InputDecoration(
    labelText: "Password",
    filled: true,
    fillColor: const Color(0xFFF5F5F5),
    labelStyle: const TextStyle(color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black, width: 1.2),
    ),
  ),
),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(isSignup
                            ? (isHotelAdmin ? "Sign Up as Hotel Admin" : "Sign Up")
                            : (isHotelAdmin ? "Login as Hotel Admin" : "Login")),
                        onPressed: () {
                          final role = isHotelAdmin ? "Hotel Admin" : "Guest";
                          final action = isSignup ? "signed up" : "logged in";

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Successfully $action as $role"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => isHotelAdmin
                                    ? const HotelOperation()
                                    : const HotelDashboard(),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isSignup = !isSignup;
                          });
                        },
                        child: Text(
                          isSignup
                              ? "Already have an account? Login"
                              : "Don't have an account? Sign Up",
                        ),
                      ),
                    ),

                    // 👇 Prevent content from being hidden by keyboard
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

}
