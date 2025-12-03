import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromosAndOffersScreen extends StatefulWidget {
  const PromosAndOffersScreen({super.key});

  @override
  State<PromosAndOffersScreen> createState() => _PromosAndOffersScreenState();
}

class _PromosAndOffersScreenState extends State<PromosAndOffersScreen> {
  final promos = [
    {
      'image': 'lib/assets/images/palaweno.jpg',
      'title': 'Palaweño Promo',
      'description':
          'Exclusive discounts for Palawan locals! Relax and unwind with special rates right in the heart of paradise.',
    },
    {
      'image': 'lib/assets/images/returning.jpg',
      'title': 'Returning Guest',
      'description':
          'Welcome back! Enjoy personalized perks and a warm return with every stay.',
    },
    {
      'image': 'lib/assets/images/2.png',
      'title': 'Book 3 Nights, Get 1 Free',
      'description':
          'Stay longer for less. Perfect for a chill escape or a thrilling Palawan adventure.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _showIntroModalIfNeeded();
  }

  Future<void> _showIntroModalIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final dontShowAgain = prefs.getBool('hidePromosIntro') ?? false;

    if (!dontShowAgain) {
      Future.delayed(Duration.zero, _showIntroModal);
    }
  }

  void _showIntroModal() {
    bool _dontShowAgain = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      
                    ),
                  ),
                  Lottie.asset(
                    'lib/assets/icons/promo.json',
                    height: 180,
                    repeat: true,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Ezee Hotel Promos & Offers!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Here are our latest deals specially curated for you. Save more and stay longer!',
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _dontShowAgain,
                        onChanged: (value) {
                          setModalState(() {
                            _dontShowAgain = value ?? false;
                          });
                        },
                      ),
                      Text(
                        "Don't show again",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      if (_dontShowAgain) {
                        await prefs.setBool('hidePromosIntro', true);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Got it!',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Promos & Offers',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: promos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final promo = promos[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  promo['image']!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                promo['title']!,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                promo['description']!,
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
