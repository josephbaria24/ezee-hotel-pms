// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Contactuspage extends StatefulWidget {
  const Contactuspage({super.key});

  @override
  State<Contactuspage> createState() => _ContactuspageState();
}

class _ContactuspageState extends State<Contactuspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Contact us", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      body: Stack(
  children: [
    // Geometric Background
    Positioned(
      top: 10,
      left: -40,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 90, 131).withOpacity(0.3), // pastel brown
          shape: BoxShape.circle,
        ),
      ),
    ),
    Positioned(
      bottom: 100,
      right: -30,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1), // soft black
          shape: BoxShape.circle,
        ),
      ),
    ),
    Positioned(
      top: 300,
      left: -300,
      child: Transform.rotate(
        angle: 0.5,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            color: Color(0xFFD2B48C).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Let's plan", style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 35,
                    ),),
                    Text("Something great!", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                ),),
                SizedBox(height: 20,),
                    Text("Need some accommodation?", style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),),
                    Text("Talk to us!", style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),),
                  ],
                ),
              ),

              SizedBox(height: 70,),
                    Container(
                      width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // soft shadow color
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/location.svg',
                          width: 50,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Reservations Office',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'El Nido, Palawan, Philippines',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
              
                    SizedBox(height: 20,),
                    Container(
                      width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // soft shadow color
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/phone.svg',
                          width: 50,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Phone',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                         const Text(
                      '12-3-456-7890',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                      ],
                    ),
                  ),
                   
                    SizedBox(height: 20,),
                    Container(
                      width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // soft shadow color
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/mail.svg',
                          width: 50,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                         const Text(
                      'ezeehotel@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                      ],
                    ),
                  ),
                    
                    const SizedBox(height: 4),
                    
                    
                    
                    const SizedBox(height: 24),
                    
                    const Divider(height: 1, thickness: 1),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Office Hours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      'Monday to Friday\n9:00 am to 8:00 pm',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      'Saturday\n9:00 am to 12:00 noon',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Divider(height: 1, thickness: 1),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Get Social',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      'Tag us in your photos!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Social media icons would go here
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.facebook, size: 30, color: Colors.black,),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Image.asset('lib/assets/icons/ig.png', width: 27),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Image.asset('lib/assets/icons/x.png', width: 27),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    ]));
  }
}