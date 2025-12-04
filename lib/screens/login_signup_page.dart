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

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  bool isSignup = false;
  bool isHotelAdmin = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      isSignup = !isSignup;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8), // Warm beige background
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Logo with fade animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Image.asset(
                          'lib/assets/images/ezee.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Welcome text
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          "Go ahead and set up\nyour account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 12),

                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          "Sign in-up to enjoy the best managing experience",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7A7A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // White card container
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Guest/Admin Toggle
                                // Container(
                                //   padding: const EdgeInsets.all(4),
                                //   decoration: BoxDecoration(
                                //     color: const Color(0xFFF5F1E8),
                                //     borderRadius: BorderRadius.circular(12),
                                //   ),
                                //   // child: Row(
                                //   //   children: [
                                //   //     Expanded(
                                //   //       child: _buildToggleButton(
                                //   //         label: "Login",
                                //   //         isSelected: !isSignup,
                                //   //         onTap: () {
                                //   //           if (isSignup) _toggleMode();
                                //   //         },
                                //   //       ),
                                //   //     ),
                                //   //     Expanded(
                                //   //       child: _buildToggleButton(
                                //   //         label: "Register",
                                //   //         isSelected: isSignup,
                                //   //         onTap: () {
                                //   //           if (!isSignup) _toggleMode();
                                //   //         },
                                //   //       ),
                                //   //     ),
                                //   //   ],
                                //   // ),
                                // ),
                                // Role Toggle (Guest/Hotel Admin)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F1E8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildToggleButton(
                                          label: "Guest",
                                          isSelected: !isHotelAdmin,
                                          onTap: () {
                                            setState(() {
                                              isHotelAdmin = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildToggleButton(
                                          label: "Hotel Admin",
                                          isSelected: isHotelAdmin,
                                          onTap: () {
                                            setState(() {
                                              isHotelAdmin = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Animated form fields
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Column(
                                    children: [
                                      // Name field (only on signup)
                                      if (isSignup) ...[
                                        _buildTextField(
                                          controller: _nameController,
                                          label: "Full Name",
                                          icon: Icons.person_outline,
                                        ),
                                        const SizedBox(height: 16),
                                      ],

                                      // Email field
                                      _buildTextField(
                                        controller: _emailController,
                                        label: "Email Address",
                                        icon: Icons.email_outlined,
                                      ),

                                      const SizedBox(height: 16),

                                      // Password field
                                      _buildTextField(
                                        controller: _passwordController,
                                        label: "Password",
                                        icon: Icons.lock_outline,
                                        isPassword: true,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Login/Signup Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 79, 58, 18), // Sage green
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      final role = isHotelAdmin ? "Hotel Admin" : "Guest";
                                      final action = isSignup ? "signed up" : "logged in";

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Successfully $action as $role"),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: const Color.fromARGB(255, 155, 141, 107),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
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
                                    child: Text(
                                      isSignup ? "Sign Up" : "Login",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Toggle text
                      TextButton(
                        onPressed: _toggleMode,
                        child: Text(
                          isSignup
                              ? "Already have an account? Login"
                              : "Don't have an account? Sign Up",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 155, 138, 107),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

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

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2C2C2C) : const Color(0xFF7A7A7A),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8E4DB),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF9A9A9A),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF9A9A9A),
            size: 20,
          ),
          suffixIcon: isPassword
              ? Icon(
                  Icons.visibility_outlined,
                  color: const Color(0xFF9A9A9A),
                  size: 20,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}