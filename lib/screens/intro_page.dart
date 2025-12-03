import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ezee/screens/login_signup_page.dart';

class OnboardingPage {
  final String title;
  final String subtitle;
  final String? caption;
  final String? footer;
  final String? backgroundPath;
  final bool isVideo;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    this.caption,
    this.footer,
    this.backgroundPath,
    this.isVideo = false,
  });
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late VideoPlayerController _videoController;


  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('lib/assets/images/bg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
  title: 'Stay in Style.\nRelax in Comfort.',
  subtitle: 'Begin your journey with curated\nhotel experiences.',
  caption: 'Where comfort meets convenience,\ndesigned just for you.',
  footer: 'intro',
  backgroundPath: 'lib/assets/images/bgintro.jpg',
),

    OnboardingPage(
      title: 'Discover more,\nWorry less.',
      subtitle: 'Find rooms, facilities, and memories\nall in one place.',
      caption: 'Everything you need. No hassle.',
      footer: 'villa costa',
      backgroundPath: 'lib/assets/images/bg2.jpg',
    ),
    OnboardingPage(
      title: 'Book Instantly.\nStay Effortlessly.',
      subtitle: 'Flexible. Instant. Seamless.',
      caption: 'The future of hospitality, now in your hands.',
      footer: 'get started',
      isVideo: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (_currentPage + 1) / _pages.length;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              if (_pages[index].isVideo && _videoController.value.isInitialized) {
                _videoController.play();
              } else {
                _videoController.pause();
              }
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  if (page.isVideo && _videoController.value.isInitialized)
                    AnimatedBuilder(
                      animation: _videoController,
                      builder: (context, child) {
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoController.value.size.width,
                            height: _videoController.value.size.height,
                            child: VideoPlayer(_videoController),
                          ),
                        );
                      },
                    )
                  else if (page.backgroundPath != null)
                    Image.asset(page.backgroundPath!, fit: BoxFit.cover)
                  else
                    Container(color: Colors.black),

                  // Overlay for darkening background
                  Container(color: Colors.black.withOpacity(0.4)),

                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 32,
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          page.subtitle,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        if (page.caption != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            page.caption!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (page.footer != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Professional footer layout
                              Row(
                                children: [
                                  Container(
                                    height: 1,
                                    width: 40,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "VILLA COSTA".toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white54,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Main footer text with gradient
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [Colors.white, Colors.white70],
                                    stops: [0.5, 1.0],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  page.footer!.toLowerCase(),
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                    height: 0.9,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Secondary text with subtle animation hint
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _currentPage == index ? 1.0 : 0.6,
                                child: const Text(
                                  "swipe to continue",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white54,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip button
          Positioned(
            top: 40,
            right: 10,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthPage()),
                );
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 14, 
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Progress bar with page indicator
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0${_currentPage + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '0${_pages.length}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 2,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}